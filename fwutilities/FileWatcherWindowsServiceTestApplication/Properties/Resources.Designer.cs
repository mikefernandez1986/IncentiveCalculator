﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.18033
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace FileWatcherUtilities.FileWatcherWindowsServiceTestApplication.Properties {
    using System;
    
    
    /// <summary>
    ///   A strongly-typed resource class, for looking up localized strings, etc.
    /// </summary>
    // This class was auto-generated by the StronglyTypedResourceBuilder
    // class via a tool like ResGen or Visual Studio.
    // To add or remove a member, edit your .ResX file then rerun ResGen
    // with the /str option, or rebuild your VS project.
    [global::System.CodeDom.Compiler.GeneratedCodeAttribute("System.Resources.Tools.StronglyTypedResourceBuilder", "4.0.0.0")]
    [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
    [global::System.Runtime.CompilerServices.CompilerGeneratedAttribute()]
    internal class Resources {
        
        private static global::System.Resources.ResourceManager resourceMan;
        
        private static global::System.Globalization.CultureInfo resourceCulture;
        
        [global::System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1811:AvoidUncalledPrivateCode")]
        internal Resources() {
        }
        
        /// <summary>
        ///   Returns the cached ResourceManager instance used by this class.
        /// </summary>
        [global::System.ComponentModel.EditorBrowsableAttribute(global::System.ComponentModel.EditorBrowsableState.Advanced)]
        internal static global::System.Resources.ResourceManager ResourceManager {
            get {
                if (object.ReferenceEquals(resourceMan, null)) {
                    global::System.Resources.ResourceManager temp = new global::System.Resources.ResourceManager("FileWatcherUtilities.FileWatcherWindowsServiceTestApplication.Properties.Resource" +
                            "s", typeof(Resources).Assembly);
                    resourceMan = temp;
                }
                return resourceMan;
            }
        }
        
        /// <summary>
        ///   Overrides the current thread's CurrentUICulture property for all
        ///   resource lookups using this strongly typed resource class.
        /// </summary>
        [global::System.ComponentModel.EditorBrowsableAttribute(global::System.ComponentModel.EditorBrowsableState.Advanced)]
        internal static global::System.Globalization.CultureInfo Culture {
            get {
                return resourceCulture;
            }
            set {
                resourceCulture = value;
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to File Watcher Windows Service Test Application {0} (C) 2009 J. Hiltunen
        ///
        ///Press [Enter] to exit the application..
        /// </summary>
        internal static string MessageApplicationInfo {
            get {
                return ResourceManager.GetString("MessageApplicationInfo", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Cannot open application log file..
        /// </summary>
        internal static string MessageCannotOpenLogFile {
            get {
                return ResourceManager.GetString("MessageCannotOpenLogFile", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Error in file watcher configuration file: {0}.
        /// </summary>
        internal static string MessageFileWatcherConfigurationError {
            get {
                return ResourceManager.GetString("MessageFileWatcherConfigurationError", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Press any key to continue....
        /// </summary>
        internal static string MessagePressAnyKeyToContinue {
            get {
                return ResourceManager.GetString("MessagePressAnyKeyToContinue", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Unexpected error occured: {0}.
        /// </summary>
        internal static string MessageUnexpectedError {
            get {
                return ResourceManager.GetString("MessageUnexpectedError", resourceCulture);
            }
        }
    }
}
