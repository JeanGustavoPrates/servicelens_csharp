FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app

COPY ./src/AwsServiceLensImplementation.Api/*.csproj ./
RUN dotnet restore

COPY ./src/AwsServiceLensImplementation.Api/ ./
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app
COPY --from=build /app/out .

ENTRYPOINT ["dotnet", "AwsServiceLensImplementation.Api.dll"]