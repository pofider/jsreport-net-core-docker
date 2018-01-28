FROM ubuntu:xenial

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
		curl \
        \
		# .NET Core dependencies
		libunwind8 \
		liblttng-ust0 \
		libcurl3 \
		ibssl1.0.0 \
		libuuid1 \
		libkrb5-3 \
		zlib1g \
		libicu55 \
    && rm -rf /var/lib/apt/lists/*

# Install .NET Core
ENV DOTNET_VERSION 2.0.5
ENV DOTNET_DOWNLOAD_URL https://dotnetcli.blob.core.windows.net/dotnet/Runtime/$DOTNET_VERSION/dotnet-runtime-$DOTNET_VERSION-linux-x64.tar.gz
ENV DOTNET_DOWNLOAD_SHA 21D54E559C5130BB3F8C38EADACB7833EC90943F71C4E9C8FA2D53192313505311230B96F1AFEB52D74D181D49CE736B83521754E55F15D96A8756921783CD33

RUN curl -SL $DOTNET_DOWNLOAD_URL --output dotnet.tar.gz \
    && echo "$DOTNET_DOWNLOAD_SHA dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -zxf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

RUN apt-get update && \   
    apt-get install -y libfontconfig1

ARG source
WORKDIR /app
COPY ${source:-obj/Docker/publish} .
ENTRYPOINT ["dotnet", "DockerNetCoreTest.dll"]
