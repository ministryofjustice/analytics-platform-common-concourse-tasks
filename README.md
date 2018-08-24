# Useful tasks

* decrypt-gitcrypt.yaml
  **DEPRECATED** This functionality is provided by the `git` resource.
  
* ec2-metadata.yaml
  Fetches AWS credentials from the EC2 instance metadata and saves it in a `credentials.json` file
  
* extract-release-tarball.yaml
  Extracts a Github release asset tarball into a specified directory
  
* get-iam-role.yaml
  Accesses the Control Panel API and fetches the IAM role name for an app associated with a specified Github repository URL
  
* parse-deploy-file.yaml
  Parses the `deploy.json` file users must create in their app repositories and outputs configuration ready to be passed to Helm `values` command line arguments
  
* webapp-docker-image.yaml
  Allows building and pushing a Docker image to a specified Docker repository, without having to specify the repository URL and credentials before build-time.
