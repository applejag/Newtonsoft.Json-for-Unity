using System;
using System.Collections.Generic;
using System.Reflection;
using NUnit.Framework;

namespace Aot.Tests
{
    [TestFixture]
    public class AotTests
    {
#if ENABLE_IL2CPP
        static AotTests()
        {
            var myAotEnsuredList = new List<MyAotEnsuredClass>();
        }

        class MyNonAotClass
        {
            public string a;
        }

        class MyAotEnsuredClass
        {
            public string b;
        }

        [Test]
        public void ThrowsOnNoAOTGenerated()
        {
            var ex = Assert.Throws<TargetInvocationException>(delegate
            {
                IList<MyNonAotClass> l = CreateListOfType<MyNonAotClass>();
            });

            Assert.IsInstanceOf<TypeInitializationException>(ex.InnerException);
        }

        [Test]
        public void PassesOnAOTGenerated()
        {
            IList<MyNonAotClass> l = CreateListOfType<MyNonAotClass>();

            Assert.Pass();
        }
#endif

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
