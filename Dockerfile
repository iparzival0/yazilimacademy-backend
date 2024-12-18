FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

COPY ["src/YazilimAcademy.Application/YazilimAcademy.Application.csproj", "YazilimAcademy.Application/"]
COPY ["src/YazilimAcademy.Domain/YazilimAcademy.Domain.csproj", "YazilimAcademy.Domain/"]
COPY ["src/YazilimAcademy.Infrastructure/YazilimAcademy.Infrastructure.csproj", "YazilimAcademy.Infrastructure/"]
COPY ["src/YazilimAcademy.WebApi/YazilimAcademy.WebApi.csproj", "YazilimAcademy.WebApi/"]

RUN dotnet restore "YazilimAcademy.WebApi/YazilimAcademy.WebApi.csproj"
COPY src/ .
WORKDIR "/src/YazilimAcademy.WebApi"
RUN dotnet build "YazilimAcademy.WebApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "YazilimAcademy.WebApi.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "YazilimAcademy.WebApi.dll"]