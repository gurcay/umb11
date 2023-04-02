# Use the SDK image to build and publish the website
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["umb11.csproj", "."]
RUN dotnet restore "umb11.csproj"
COPY . .
RUN dotnet publish "umb11.csproj" -c Release -o /app/publish

# Copy the published output to the final running image
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS final 
WORKDIR /app

# Copy the published output to the final running image
COPY --from=build /app/publish .

# Copy the media items to the final running image
COPY ./wwwroot/media ./wwwroot/media

COPY ./umbraco/Data/Umbraco.sqlite.db ./umbraco/Data/Umbraco.sqlite.db

# Set the entrypoint to the web application
ENTRYPOINT ["dotnet", "umb11.dll"]