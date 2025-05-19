# Images

## *Ubuntu*
> **[ubuntu](https://hub.docker.com/repository/docker/armck/ubuntu)**  
  **Description**: Ubuntu image with standardized development tools  
  **From**: [ubuntu](https://hub.docker.com/_/ubuntu)  
  **Features**: apt-utils, curl, git, and more..  
  **Tags**: `20.04`, `22.04`, `24.04`  
  **Template Repositories**: [template-ubuntu](https://github.com/armckinney/template-ubuntu)  

## *Terraform*
> **[terraform](https://hub.docker.com/repository/docker/armck/terraform)**  
  **Description**: Enhanced Ubuntu image with tools for Terraform Infrastructure Management  
  **From**: [ubuntu](https://hub.docker.com/repository/docker/armck/ubuntu)  
  **Features**: terraform  
  **Tags**: `1.10.5`  

> **[terraform-azure](https://hub.docker.com/repository/docker/armck/terraform-azure)**  
  **Description**: Enhanced Terraform image with tools for Azure Terraform Infrastructure Management  
  **From**: [terraform](https://hub.docker.com/repository/docker/armck/terraform)  
  **Features**: azure-cli  
  **Tags**: `2.73.0`   

## *Python*
> **[python](https://hub.docker.com/repository/docker/armck/python)**  
  **Description**: Python image with standardized development tools  
  **From**: [ubuntu](https://hub.docker.com/repository/docker/armck/ubuntu)  
  **Features**: dependency management (poetry or uv)  
  **Tags**: `3.9.5`, `3.12.3`  
  **Template Repositories**: [template-python](https://github.com/armckinney/template-python)

## *Pyspark*
> **[pyspark](https://hub.docker.com/repository/docker/armck/pyspark)**  
  **Description**: Enhanced Python image with Java installed for pyspark  
  **From**: [python](https://hub.docker.com/repository/docker/armck/python)  
  **Features**: Zulu Java SDK, pyspark  
  **Tags**: `3.2.2` 
  **Template Repositories**: [template-pyspark](https://github.com/armckinney/template-pyspark)

## *.NET*
> **[dotnet](https://hub.docker.com/repository/docker/armck/dotnet)**  
  **Description**: Enhanced Ubuntu image with the .NET SDK installed  
  **From**: [ubuntu](https://hub.docker.com/repository/docker/armck/ubuntu)  
  **Features**: .NET SDK  
  **Tags**: `7.0`, `8.0`  
  **Template Repositories**: [template-dotnet](https://github.com/armckinney/template-dotnet)