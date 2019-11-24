using System;
using System.Collections.Generic;
using System.Reflection;
using NUnit.Framework;

namespace Aot.Tests
{
    /// <summary>
    /// Tests are only relevant for AOT builds, such as when using IL2CPP
    /// </summary>
    [TestFixture]
    public class AotTests
    {
        private class MyNonAotClass
        {
#pragma warning disable 649 // Field is never assigned to, and will always have its default value `null'
            public string a;
        }

        private class MyAotEnsuredClass
        {
            public string b;
#pragma warning restore 649 // Field is never assigned to, and will always have its default value `null'
        }

        [Test]
        public void ThrowsOnNoAOTGenerated()
        {
            var ex = Assert.Throws<TargetInvocationException>(delegate
            {
                _ = CreateListOfType<MyNonAotClass>();
            });

            Assert.IsInstanceOf<TypeInitializationException>(ex.InnerException);
        }

        [Test]
        public void PassesOnAOTGenerated()
        {
            _ = CreateListOfType<MyNonAotClass>();

            Assert.Pass();
        }

        static object CreateListOfType(Type type)
        {
            return typeof(List<>).MakeGenericType(type).GetConstructor(new Type[0]).Invoke(new object[0]);
        }

        static List<T> CreateListOfType<T>()
        {
            return (List<T>) CreateListOfType(typeof(T));
        }
    }
}
