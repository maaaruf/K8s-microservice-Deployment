FROM ubuntu:22.04

# Update the package list and install necessary dependencies
RUN apt update && \
    apt install -y curl wget unzip git make && \
    rm -rf /var/lib/apt/lists/*

# Download and install Terraform
RUN wget -q https://releases.hashicorp.com/terraform/1.3.9/terraform_1.3.9_linux_amd64.zip && \
    unzip terraform_1.3.9_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_1.3.9_linux_amd64.zip

# Download and Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install

# Copy the Terraform files to the container's working directory
# Set the working directory to /terraform
WORKDIR /terraform
COPY . /terraform