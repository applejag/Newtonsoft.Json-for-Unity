
# Possible alterations of UNITY_VERSION argument, using example 2018.3.11f1:
# 2018.3.11f1               : all modules
# 2018.3.11f1-unity         : no modules
# 2018.3.11f1-windows       : Windows module
# 2018.3.11f1-mac           : Mac OS X module
# 2018.3.11f1-ios           : iOS module
# 2018.3.11f1-android       : Android module
# 2018.3.11f1-webgl         : WebGL module
# 2018.3.11f1-facebook      : Facebook module
ARG UNITY_VERSION=2019.1.14f1
FROM gableroux/unity3d:${UNITY_VERSION}

# Add trusted sources
RUN mkdir -p ~/.ssh \
    # Fingerprint to github.com
    && echo "|1|/olfPnpeGUgKkhLlwJSy4ro3Hb8=|tXqFHMrM0PWDFuQmABAg7zYndWc= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==" \
        >> ~/.ssh/known_hosts

# Install utils
RUN echo "\n>>> Installing tools\n" \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
        mono-devel=4.6.2.7+dfsg-1ubuntu1 \
        git=1:2.17.1-1ubuntu0.4 \
        ssh=1:7.6p1-4ubuntu0.3 \
        curl=7.58.0-2ubuntu3.8 \
        xmlstarlet=1.6.1-2 \
        jq=1.5+dfsg-2 \
        # Required for Powershell installation
        apt-transport-https=1.6.12 \
        ca-certificates=20180409 \
    # Special requirement for Unity 2019.1 and above
    && ([ -z "$(echo '${UNITY_VERSION}' | egrep '2018.*|2017.*|5.*')" ] || exit 0 \
        && echo "\n>>> Unity 2019.1.0f2 or above, installing additional libraries\n" \
        && apt-get install --no-install-recommends -y \
            libunwind-dev=* \
    ) \
    && echo "\n>>> Installing PowerShell\n" \
    && wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
        powershell=6.2.2-1.ubuntu.18.04 \
    # Cleanup
    && echo "\n>>> Cleaning up apt-get cache\n" \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY setup.ps1 /tmp/setup.ps1
RUN chmod +x /tmp/setup.ps1 \
    && pwsh /tmp/setup.ps1 -TempDirectory /tmp -PackageDirectory ~/nuget \
    # Cleanup
    && rm -rf ~/tmp \
    && rm /tmp/setup.ps1
