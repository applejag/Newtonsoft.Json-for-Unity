#region License
// The MIT License (MIT)
//
// Copyright (c) 2016 SaladLab
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
#endregion

using System;
using System.Collections;
using System.Collections.Generic;

namespace Newtonsoft.Json.Utilities
{
    /// <summary>
    /// 
    /// </summary>
    public static class AotHelper
    {
        /// <summary>
        /// Don't run action but let a compiler detect the code in action as an executable block.
        /// </summary>
        public static void Ensure(Action action)
        {
            if (IsFalse())
            {
                try
                {
                    action();
                }
                catch (Exception e)
                {
                    throw new InvalidOperationException("", e);
                }
            }
        }

        /// <summary>
        /// Ensure(() => new T());
        /// </summary>
        public static void EnsureType<T>() where T : new()
        {
            Ensure(() => new T());
        }

        /// <summary>
        /// Ensure generic list type can be (de)deserializable on AOT environment.
        /// </summary>
        /// <typeparam name="T">The type of elements in the list</typeparam>
        public static void EnsureList<T>()
        {
            Ensure(() =>
            {
                var a = new List<T>();
                var b = new HashSet<T>();
                var c = new CollectionWrapper<T>((IList)a);
                var d = new CollectionWrapper<T>((ICollection<T>)a);
            });
        }

        /// <summary>
        /// Ensure generic dictionary type can be (de)deserializable on AOT environment.
        /// </summary>
        /// <typeparam name="TKey">The type of the keys in the dictionary.</typeparam>
        /// <typeparam name="TValue">The type of the values in the dictionary.</typeparam>
        public static void EnsureDictionary<TKey, TValue>()
        {
            Ensure(() =>
            {
                var a = new Dictionary<TKey, TValue>();
                var b = new DictionaryWrapper<TKey, TValue>((IDictionary)null);
                var c = new DictionaryWrapper<TKey, TValue>((IDictionary<TKey, TValue>)null);
            });
        }

        private static bool s_alwaysFalse = DateTime.UtcNow.Year < 0;

        /// <summary>
        /// Always return false but compiler doesn't know it.
        /// </summary>
        /// <returns>False</returns>
        public static bool IsFalse()
        {
            return s_alwaysFalse;
        }
    }
}