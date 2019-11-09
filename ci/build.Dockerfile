FROM applejag/newtonsoft.json-for-unity:latest

ARG BUILD_CONFIGURATION=Release
ARG BUILD_FRAMEWORK
ARG BUILD_UNITY=Standalone
ARG BUILD_SOLUTION=~/repo/Src/Newtonsoft.Json/Newtonsoft.Json.csproj
ARG BUILD_DESTINATION_BASE=~/repo/Src/Newtonsoft.Json-for-Unity/Plugins

ARG UNITY_LICENSE_CONTENT_B64

ENV UNITY_LICENSE_CONTENT_B64=${UNITY_LICENSE_CONTENT_B64} \
    BUILD_FRAMEWORK=${BUILD_FRAMEWORK} \
    BUILD_SOLUTION=${BUILD_SOLUTION} \
    BUILD_DESTINATION_BASE=${BUILD_DESTINATION_BASE}

WORKDIR /root/repo

RUN echo ">>> OBTAINING VERSION FROM /root/repo/ci/version.json" \
    && export VERSION="$($SCRIPTS/get_json_version.sh ./ci/version.json FULL)" \
    && echo "VERSION='$VERSION'" \
    && export VERSION_SHORT="$($SCRIPTS/get_json_version.sh ./ci/version.json SHORT)" \
    && echo "VERSION_SHORT='$VERSION_SHORT'" \
    && export VERSION_SUFFIX="$($SCRIPTS/get_json_version.sh ./ci/version.json SUFFIX)" \
    && echo "VERSION_SUFFIX='$VERSION_SUFFIX'" \
    && echo \
    && echo ">>> ENSURE VALID BUILD CONFIGURATION" \
    && echo "BUILD_CONFIGURATION='$BUILD_CONFIGURATION'" \
    && echo "BUILD_UNITY='$BUILD_UNITY'" \
    && export BUILD_FRAMEWORK="$($SCRIPTS/get_framework_from_build.sh "${BUILD_UNITY}")" \
    && echo "BUILD_FRAMEWORK='$BUILD_FRAMEWORK'" \
    && (! [ -f "$BUILD_SOLUTION" ] || exit 0 \
        && >&2 echo "Build solution '$BUILD_SOLUTION' not found!" \
        && exit 1 \
    ) \
    && echo "BUILD_SOLUTION='$BUILD_SOLUTION'" \
    && echo "BUILD_DESTINATION_BASE='$BUILD_DESTINATION_BASE'" \
    && export BUILD_DESTINATION="${BUILD_DESTINATION:-"$BUILD_DESTINATION_BASE/Newtonsoft.Json $BUILD_UNITY"}" \
    && echo "BUILD_DESTINATION='$BUILD_DESTINATION'" \
    && echo

RUN msbuild -t:build -restore "$BUILD_SOLUTION" \
    -p:Configuration="$BUILD_CONFIGURATION" \
    -p:LibraryFrameworks="$BUILD_FRAMEWORK" \
    -p:OutputPath="$BUILD_DESTINATION" \
    -p:UnityBuild="$BUILD_UNITY" \
    -p:VersionPrefix="$VERSION_SHORT" \
    -p:VersionSuffix="$VERSION_SUFFIX" \
    -p:AssemblyVersion="$VERSION_SHORT" \
    -p:FileVersion="$VERSION"

RUN $SCRIPTS/build.sh "$BUILD_UNITY" "$BUILD_SOLUTION"

