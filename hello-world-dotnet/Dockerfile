# Use the official .NET SDK image as a build environment
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /source

# Copy and restore dependencies
COPY hello-world-dotnet.csproj ./
RUN dotnet restore

# Copy the rest of the application and publish
COPY . ./
RUN dotnet publish -c Release -o /app

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build-env /app .

# Set environment variables
ENV ASPNETCORE_URLS=http://+:5000
ENV ASPNETCORE_ENVIRONMENT=Development

# Expose the port
EXPOSE 5000

ENTRYPOINT ["dotnet", "hello-world-dotnet.dll"]
