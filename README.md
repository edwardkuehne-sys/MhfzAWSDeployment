<!-- ABOUT THE PROJECT -->
## About The Project

This repository provides an easy-to-use template and framework for deploying a containerized Monster Hunter Frontier Server on AWS Infrastructure in a single deployment, even for users with limited AWS experience.
The deployment tries to stay as close to the free tier as possible while providing a stable deployment.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->
## Getting Started

You need an AWS account with linked billing information.

### Prerequisites

A S3 bucket with the server's binaries is required to be set up beforehand. You can use the following command after setting your desired availability-zone.
* AWS cli
  ```sh
  aws s3 mb s3://YOUR-BUCKET-NAME --region $(aws configure get region)
  ```
Before uploading the archive you need to rename it to 'MHFZbinaries.7z'
Afterwards you can upload the archive containing the binaries to the bucket.
It is important that the chosen bucket name matches the bucket referenced in deploy.sh.

Your final bucket structure should look as follows:
  ```text
  YOUR-BUCKET-NAME/
  └── MHFZbinaries.7z
  ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- USAGE EXAMPLES -->
## Usage

Navigate to Cloudformation and create a new stack with deployment.yaml. 

_For more examples, please refer to the [Documentation](https://example.com)_

<p align="right">(<a href="#readme-top">back to top</a>)</p>

