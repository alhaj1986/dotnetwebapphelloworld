# official .NET SDK image as a build environment

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build-env
WORKDIR /source

# Copy and restore dependencies
COPY hello-world-dotnet.csproj ./
RUN dotnet restore

# Copy the rest of the application and publish
COPY . ./
RUN dotnet publish -c Release -o /app

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app
COPY --from=build-env /app .

ENTRYPOINT ["dotnet", "hello-world-dotnet.dll"]
