using System;
using System.Collections.Generic;
using System.Numerics;
using Newtonsoft.Json.Utilities;
using NUnit.Framework;
using UnityEngine;

namespace Newtonsoft.Json.Tests.Aot
{
    [TestFixture]
    public class EnsureTypes
    {
        [SetUp]
        public void TestInitialize()
        {
            AotHelper.EnsureList<DateTime>(); // used in DeserializeDateFormatString
            AotHelper.EnsureList<Guid>(); // used in BsonReaderTests
            AotHelper.EnsureList<KeyValuePair<string, int>>(); // used in KeyValuePairConverterTests
            AotHelper.EnsureList<KeyValuePair<string, string>>(); // used in Issue1322
            AotHelper.EnsureList<int>(); // used in ContractResolverTests.ListInterfaceDefaultCreator
            AotHelper.EnsureList<int?>(); // used in JsonSerializerCollectionsTests.DeserializeIEnumerableFromConstructor
            AotHelper.EnsureList<KeyValuePair<string, IList<string>>>(); // used in JsonSerializerCollectionsTests.DeserializeKeyValuePairArray
            AotHelper.EnsureList<KeyValuePair<string, IList<string>>?>(); // used in JsonSerializerCollectionsTests.DeserializeNullableKeyValuePairArray
            AotHelper.EnsureList<decimal>(); // used in JsonSerializerTest.CommentTestClassTest
            AotHelper.EnsureList<bool>(); // used in JsonSerializerTest.DeserializeBooleans
            AotHelper.EnsureDictionary<string, decimal>(); // used in JsonSerializerTest.DeserializeDecimalDictionaryExact
            AotHelper.EnsureDictionary<string, int>(); // used in JsonSerializerCollectionsTests.SerializeCustomReadOnlyDictionary
            AotHelper.EnsureList<double?>(); // used in JsonSerializerTest.DeserializeNullableArray
            AotHelper.EnsureList<double>(); // used in JsonSerializerTest.ReadStringFloatingPointSymbols
            AotHelper.EnsureList<bool?>(); // used in JsonSerializerTest.DeserializeNullableBooleans
            AotHelper.EnsureList<DateTimeOffset?>(); // used in JsonSerializerTest.ReadForTypeHackFixDateTimeOffset
            AotHelper.EnsureList<float>(); // used in JsonSerializerTest.ReadStringFloatingPointSymbols
            AotHelper.EnsureList<BigInteger>(); // used in JsonSerializerTest.ReadTooLargeInteger
            AotHelper.EnsureList<long>(); // used in JsonSerializerTest.ReadTooLargeInteger
        }
    }
}