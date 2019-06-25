﻿/******************************************************************************
*    File Watcher Utilities / File Watcher Controller
*    Copyright (c) 2006-2013 Jussi Hiltunen
*
*    This program is free software; you can redistribute it and/or modify
*    it under the terms of the GNU General Public License as published by
*    the Free Software Foundation; either version 2 of the License, or
*    (at your option) any later version.
*
*    This program is distributed in the hope that it will be useful,
*    but WITHOUT ANY WARRANTY; without even the implied warranty of
*    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*    GNU General Public License for more details.
*
*    You should have received a copy of the GNU General Public License
*    along with this program; if not, write to the Free Software
*    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
******************************************************************************/

using System;
using FileWatcherUtilities.Controller.Properties;

namespace FileWatcherUtilities.Controller
{
    /// <summary>
    /// Provides data for ServiceCalled event.
    /// </summary>
    public class ServiceCalledEventArgs : EventArgs
    {
        /// <summary>
        /// Initializes a new instance of the ServiceCalledEventArgs class.
        /// </summary>
        /// <param name="daemonName">The name of the daemon which is calling the service.</param>
        /// <param name="message">Message returned form the service.</param>
        /// <param name="id">Event identifier.</param>
        /// <exception cref="ArgumentNullException">daemonName is null.</exception>
        /// <exception cref="ArgumentException">id is Guid.Empty.</exception>
        public ServiceCalledEventArgs(string daemonName,
                                      string message,
                                      Guid id)
        {
            if (daemonName == null)
            {
                throw new ArgumentNullException("daemonName",
                                                Resources.ArgumentNullException);
            }
            _daemonName = daemonName;

            if (message != null)
            {
                _message = message;
            }
            if (id == Guid.Empty)
            {
                throw new ArgumentException(Resources.ArgumentExceptionIdIsEmpty,
                                            "id");
            }
            _guid = id;
        }

        /// <summary>
        /// Gets the name of the daemon which is calling the service.
        /// </summary>
        public string DaemonName
        {
            get
            {
                return _daemonName;
            }
        }

        /// <summary>
        /// Gets the message returned from the service. Default is empty string.
        /// </summary>
        public string Message
        {
            get
            {
                return _message;
            }
        }

        /// <summary>
        /// Identifies event.
        /// </summary>
        public Guid Id
        {
            get
            {
                return _guid;
            }
        }

        /// <summary>
        /// Identifies event.
        /// </summary>
        private readonly Guid _guid;

        /// <summary>
        /// Contains the name of the daemon which is calling the service.
        /// </summary>
        private readonly string _daemonName;

        /// <summary>
        /// Contains the message returned from the service.
        /// </summary>
        private readonly string _message = String.Empty;
    }
}