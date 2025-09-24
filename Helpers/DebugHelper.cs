using System;
using System.Linq;
using System.Reflection;
using System.Runtime.CompilerServices;
using Newtonsoft.Json;

public static class DebugHelper
{
    /// <summary>
    /// Prints all public instance properties (reflection-based),
    /// or the whole object as JSON if printAsJson = true.
    /// Always shows derived + base properties. Returns the printed string.
    /// </summary>
    public static string PrintObject(
        object obj,
        bool toError = false,
        bool printAsJson = false,
        [CallerMemberName] string memberName = "",
        [CallerFilePath] string filePath = "",
        [CallerLineNumber] int lineNumber = 0)
    {
        string header = FormatHeader(memberName, filePath, lineNumber);

        if (obj == null)
        {
            string nil = $"{header} null";
            WriteOutput(nil, toError);
            return nil;
        }

        string output;

        if (printAsJson)
        {
            // serialize entire object directly
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

        WriteOutput(output, toError);
        return output;
    }

    /// <summary>
    /// Pretty-prints exception info (with inner exceptions).
    /// </summary>
    public static string PrintException(
        Exception ex,
        bool toError = true,
        [CallerMemberName] string memberName = "",
        [CallerFilePath] string filePath = "",
        [CallerLineNumber] int lineNumber = 0)
    {
        string header = FormatHeader(memberName, filePath, lineNumber);
        if (ex == null)
        {
            string nil = $"{header} Exception is null";
            WriteOutput(nil, toError);
            return nil;
        }

        var sb = new System.Text.StringBuilder();
        sb.AppendLine(header);
        AppendException(sb, ex, 0);

        string output = sb.ToString();
        WriteOutput(output, toError);
        return output;
    }

    /// <summary>
    /// Shorthand Console.WriteLine with header info.
    /// </summary>
    public static void Log(
        object message,
        bool toError = false,
        [CallerMemberName] string memberName = "",
        [CallerFilePath] string filePath = "",
        [CallerLineNumber] int lineNumber = 0)
    {
        string header = FormatHeader(memberName, filePath, lineNumber);
        string text = $"{header} {message ?? "null"}";
        WriteOutput(text, toError);
    }

    /// <summary>
    /// Shorthand Console.WriteLine (no header, just plain).
    /// </summary>
    public static void LogRaw(object message, bool toError = false)
    {
        WriteOutput(message?.ToString() ?? "null", toError);
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

    private static void WriteOutput(string text, bool toError)
    {
        var sb = new System.Text.StringBuilder();

        sb.AppendLine("----------Begin DebugHelper--------------");
        sb.AppendLine();
        sb.AppendLine(text.TrimEnd()); // trim trailing blank space
        sb.AppendLine();
        sb.AppendLine("----------End DebugHelper--------------");
        sb.AppendLine(); // extra line for spacing between multiple logs

        string wrapped = sb.ToString();

        if (toError) Console.Error.WriteLine(wrapped);
        else Console.Out.WriteLine(wrapped);
    }
}
