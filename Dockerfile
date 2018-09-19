# ======================================
# Build Stage
# ======================================
FROM microsoft/dotnet-framework:4.7.2-sdk AS build
WORKDIR /app

# Restore dependencies with nuget
COPY *.sln .
COPY Howdy/*.csproj ./Howdy/
COPY Howdy/*.config ./Howdy/
RUN nuget restore

# Copy remaining files and build application
COPY Howdy/. ./Howdy/
WORKDIR /app/Howdy
RUN msbuild /p:Configuration=Release

# ======================================
# Runtime Stage
# ======================================
FROM microsoft/aspnet:4.7.2 AS runtime
WORKDIR /inetpub/wwwroot
COPY --from=0 /app/Howdy/. ./
