FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
USER app
WORKDIR /app
EXPOSE 8080
EXPOSE 8443

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["src/YazilimAcademy.WebApi/YazilimAcademy.WebApi.csproj", "src/YazilimAcademy.WebApi/"]
COPY ["src/YazilimAcademy.Application/YazilimAcademy.Application.csproj", "src/YazilimAcademy.Application/"]
COPY ["src/YazilimAcademy.Domain/YazilimAcademy.Domain.csproj", "src/YazilimAcademy.Domain/"]
COPY ["src/YazilimAcademy.Infrastructure/YazilimAcademy.Infrastructure.csproj", "src/YazilimAcademy.Infrastructure/"]
RUN dotnet restore "./src/YazilimAcademy.WebApi/YazilimAcademy.WebApi.csproj"
COPY . .
WORKDIR "/src/src/YazilimAcademy.WebApi"
RUN dotnet build "./YazilimAcademy.WebApi.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./YazilimAcademy.WebApi.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "YazilimAcademy.WebApi.dll"]