//using JavaScriptEngineSwitcher.ChakraCore;
//using JavaScriptEngineSwitcher.Core;
//using JavaScriptEngineSwitcher.Jint;
//using JavaScriptEngineSwitcher.Msie;
//using JavaScriptEngineSwitcher.Vroom;
//using JSPool;
//using MsieJavaScriptEngine;
//using System;
//using System.Collections.Generic;
//using System.IO;
//using System.Linq;
//using System.Threading.Tasks;

//namespace ExpressBase.Common
//{
//    public class Engine : IDisposable
//    {
//        private IJsPool pool;

//        private string initJs;

//        public Engine()
//        {
//            JsEngineSwitcher.Instance.EngineFactories.AddMsie(new MsieSettings() { EngineMode = JavaScriptEngineSwitcher.Msie.JsEngineMode.Auto });
//            //JsEngineSwitcher.Instance.DefaultEngineName = JavaScriptEngineSwitcher.Msie.MsieJsEngine.EngineName;

//            //JsEngineSwitcher.Instance.EngineFactories.AddV8();
//            //JsEngineSwitcher.Instance.DefaultEngineName = V8JsEngine.EngineName;

//            JsEngineSwitcher.Instance.EngineFactories.AddJint(new JintSettings() { });
//            //JsEngineSwitcher.Instance.DefaultEngineName = JintJsEngine.EngineName;

//            //JsEngineSwitcher.Instance.EngineFactories.AddJurassic();
//            //JsEngineSwitcher.Instance.DefaultEngineName = JurassicJsEngine.EngineName;

//            JsEngineSwitcher.Instance.EngineFactories.AddChakraCore();
//            JsEngineSwitcher.Instance.DefaultEngineName = ChakraCoreJsEngine.EngineName;

//            JsEngineSwitcher.Instance.EngineFactories.AddVroom();
//            //JsEngineSwitcher.Instance.DefaultEngineName = VroomJsEngine.EngineName;

//            initJs = ReadInitFile(@"Resources\xdate.js");

//            var config = new JsPoolConfig()
//            {
//                Initializer = initEngine =>
//                {
//                    initEngine.Execute(initJs);
//                }
//            };

//            pool = new JsPool(config);
//        }

//        public string Execute(string command)
//        {
//            var result = string.Empty;

//            var engine = pool.GetEngine();
//            try
//            {
//                result = engine.Evaluate<string>(command);
//            }
//            finally
//            {
//                pool.ReturnEngineToPool(engine);
//            }

//            return result;
//        }

//        protected string ReadInitFile(string path)
//        {
//            // This text is added only once to the file.
//            if (File.Exists(path))
//            {
//                // Create a file to write to.
//                return File.ReadAllText(path);
//            }

//            return null;
//        }

//        public void Dispose()
//        {
//            pool.Dispose();
//        }
//    }
//}
