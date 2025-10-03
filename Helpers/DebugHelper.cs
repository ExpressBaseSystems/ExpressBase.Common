using System;
using System.Linq;
using System.Reflection;
using System.Runtime.CompilerServices;
using Newtonsoft.Json;

/// <summary>
/// DebugHelper provides easy logging for objects, exceptions, and raw messages.
/// Automatically adds caller info (file, line, method).
/// You can optionally pass a "label" to distinguish logs (it will appear in the banner).
/// </summary>
public static class DebugHelper
{
    /// <summary>
    /// Prints all public instance properties of an object (via reflection),
    /// or the whole object as JSON if printAsJson = true.
    /// </summary>
    public static string PrintObject(
        object obj,
        bool toError = false,
        bool printAsJson = false,
        string label = null,
        [CallerMemberName] string memberName = "",
        [CallerFilePath] string filePath = "",
        [CallerLineNumber] int lineNumber = 0)
    {
        string header = FormatHeader(memberName, filePath, lineNumber);

        if (obj == null)
        {
            string nil = $"{header} null";
            WriteOutput(nil, toError, label);
            return nil;
        }

        string output;

        if (printAsJson)
        {
            try
            {
                string json = JsonConvert.SerializeObject(obj, Formatting.Indented,
                    new JsonSerializerSettings
                    {
                        ReferenceLoopHandling = ReferenceLoopHandling.Ignore,
                        NullValueHandling = NullValueHandling.Ignore
                    });
                output = $"{header}\n{json}";
            }
            catch (Exception ex)
            {
                output = $"{header}\n<error serializing to JSON: {ex.GetType().Name}: {ex.Message}>";
            }
        }
        else
        {
            var sb = new System.Text.StringBuilder();
            sb.AppendLine(header);
            var type = obj.GetType();
            sb.AppendLine($"Type: {type.FullName}");

            var props = type.GetProperties(BindingFlags.Public | BindingFlags.Instance)
                            .Where(p => p.GetIndexParameters().Length == 0)
                            .OrderBy(p => p.Name);

            foreach (var p in props)
            {
                object val;
                try
                {
                    val = p.GetValue(obj);
                }
                catch (Exception ex)
                {
                    val = $"<error reading: {ex.GetType().Name}: {ex.Message}>";
                }
                sb.AppendLine($"  {p.Name} = {FormatValue(val)}");
            }

            output = sb.ToString();
        }

        WriteOutput(output, toError, label);
        return output;
    }

    /// <summary>
    /// Pretty-prints exception info (with inner exceptions).
    /// </summary>
    public static string PrintException(
        Exception ex,
        bool toError = true,
        string label = null,
        [CallerMemberName] string memberName = "",
        [CallerFilePath] string filePath = "",
        [CallerLineNumber] int lineNumber = 0)
    {
        string header = FormatHeader(memberName, filePath, lineNumber);
        if (ex == null)
        {
            string nil = $"{header} Exception is null";
            WriteOutput(nil, toError, label);
            return nil;
        }

        var sb = new System.Text.StringBuilder();
        sb.AppendLine(header);
        AppendException(sb, ex, 0);

        string output = sb.ToString();
        WriteOutput(output, toError, label);
        return output;
    }

    /// <summary>
    /// Shorthand log with caller info.
    /// </summary>
    public static void Log(
        object message,
        bool toError = false,
        string label = null,
        [CallerMemberName] string memberName = "",
        [CallerFilePath] string filePath = "",
        [CallerLineNumber] int lineNumber = 0)
    {
        string header = FormatHeader(memberName, filePath, lineNumber);
        string text = $"{header} {message ?? "null"}";
        WriteOutput(text, toError, label);
    }

    /// <summary>
    /// Shorthand log without caller info (raw message only).
    /// </summary>
    public static void LogRaw(
        object message,
        bool toError = false,
        string label = null)
    {
        WriteOutput(message?.ToString() ?? "null", toError, label);
    }

    // ===== Helpers =====

    private static string FormatValue(object val)
    {
        if (val == null) return "null";
        if (val is string) return $"\"{val}\"";
        if (val.GetType().IsPrimitive) return val.ToString();

        try
        {
            return JsonConvert.SerializeObject(val, Formatting.None,
                new JsonSerializerSettings
                {
                    ReferenceLoopHandling = ReferenceLoopHandling.Ignore,
                    NullValueHandling = NullValueHandling.Ignore
                });
        }
        catch
        {
            return val.ToString();
        }
    }

    private static void AppendException(System.Text.StringBuilder sb, Exception ex, int depth)
    {
        string indent = new string(' ', depth * 2);
        sb.AppendLine($"{indent}=== Exception ===");
        sb.AppendLine($"{indent}Type: {ex.GetType().FullName}");
        sb.AppendLine($"{indent}Message: {ex.Message}");
        sb.AppendLine($"{indent}StackTrace: {ex.StackTrace ?? "<no stacktrace>"}");

        if (ex.InnerException != null)
        {
            sb.AppendLine($"{indent}--- Inner Exception ---");
            AppendException(sb, ex.InnerException, depth + 1);
        }
    }

    private static string FormatHeader(string memberName, string filePath, int lineNumber)
    {
        string time = DateTime.UtcNow.ToString("o");
        string file = string.IsNullOrEmpty(filePath) ? "<unknown file>" : System.IO.Path.GetFileName(filePath);
        return $"[{time}] [{memberName} at {file}:{lineNumber}]";
    }

    /// <summary>
    /// Writes output to console with Begin/End banners.
    /// If "label" is provided, it appears in the banners.
    /// </summary>
    private static void WriteOutput(string text, bool toError, string label = null)
    {
        var sb = new System.Text.StringBuilder();

        // Build begin/end lines dynamically
        string begin = label == null
            ? "----------BEGIN DEBUG--------------"
            : $"----------BEGIN DEBUG ({label})--------------";

        string end = label == null
            ? "----------END DEBUG--------------"
            : $"----------END DEBUG ({label})--------------";

        sb.AppendLine(begin);
        sb.AppendLine();
        sb.AppendLine(text.TrimEnd());
        sb.AppendLine();
        sb.AppendLine(end);
        sb.AppendLine(); // spacing between multiple logs

        string wrapped = sb.ToString();

        if (toError) Console.Error.WriteLine(wrapped);
        else Console.Out.WriteLine(wrapped);
    }
}
