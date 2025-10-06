# Base runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

# Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["Proveedores.Api/Proveedores.Api.csproj", "Proveedores.Api/"]
RUN dotnet restore "Proveedores.Api/Proveedores.Api.csproj"
COPY . .
WORKDIR "/src/Proveedores.Api"
RUN dotnet build "Proveedores.Api.csproj" -c Release -o /app/build

# Publish
FROM build AS publish
RUN dotnet publish "Proveedores.Api.csproj" -c Release -o /app/publish

# Final
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENV ASPNETCORE_URLS=http://+:8080
ENTRYPOINT ["dotnet", "Proveedores.Api.dll"]
