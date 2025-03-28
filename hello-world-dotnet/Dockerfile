# Use the latest official .NET SDK image as a build environment
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /source

# Install updates for base image packages
RUN apt-get update && apt-get upgrade -y && apt-get install --only-upgrade perl-base

# Copy and restore dependencies
COPY hello-world-dotnet.csproj ./
RUN dotnet restore

# Copy the rest of the application and publish
COPY . ./
RUN dotnet publish -c Release -o /app

# Use the latest official .NET ASP.NET runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

# Install updates for base image packages
RUN apt-get update && apt-get upgrade -y && apt-get install --only-upgrade perl-base

COPY --from=build-env /app .

# Set environment variables
ENV ASPNETCORE_URLS=http://+:5000
ENV ASPNETCORE_ENVIRONMENT=Development

# Expose the port
EXPOSE 5000

ENTRYPOINT ["dotnet", "hello-world-dotnet.dll"]
