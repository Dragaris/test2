# Trigger para PR Checks
resource "google_cloudbuild_trigger" "pr_checks" {
  name        = "pr-checks"
  description = "Trigger for PR checks"
  location    = var.region
  project     = var.cicd_runner_project_id

  repository_event_config {
    repository = "projects/${var.cicd_runner_project_id}/locations/${var.region}/connections/${var.host_connection_name}/repositories/${var.repository_name}"
    pull_request {
      branch = "main"
    }
  }

  filename = "deployment/ci/pr_checks.yaml"

  included_files = [
    "app/**",
    "data_processing/**",
    "tests/**",
    "deployment/**",
    "poetry.lock",
  ]

  service_account = "projects/${var.cicd_runner_project_id}/serviceAccounts/${var.cicd_runner_sa_name}@${var.cicd_runner_project_id}.iam.gserviceaccount.com"
}

# Trigger para CD Pipeline
resource "google_cloudbuild_trigger" "cd_pipeline" {
  name        = "cd-pipeline"
  description = "Trigger for CD pipeline"
  location    = var.region
  project     = var.cicd_runner_project_id

  repository_event_config {
    repository = "projects/${var.cicd_runner_project_id}/locations/${var.region}/connections/${var.host_connection_name}/repositories/${var.repository_name}"
    push {
      branch = "main"
    }
  }

  filename = "deployment/cd/staging.yaml"

  included_files = [
    "app/**",
    "data_processing/**",
    "tests/**",
    "deployment/**",
    "poetry.lock",
  ]

  substitutions = {
    _STAGING_PROJECT_ID            = var.staging_project_id
    _REGION                       = var.region
    _ARTIFACT_REGISTRY_REPO_NAME  = var.artifact_registry_repo_name
    _CLOUD_RUN_APP_SA_NAME       = var.cloud_run_app_sa_name
    _BUCKET_NAME_LOAD_TEST_RESULTS = "${var.staging_project_id}-${var.suffix_bucket_name_load_test_results}"
  }

  service_account = "projects/${var.cicd_runner_project_id}/serviceAccounts/${var.cicd_runner_sa_name}@${var.cicd_runner_project_id}.iam.gserviceaccount.com"
}

# Trigger para Deploy to Production
resource "google_cloudbuild_trigger" "deploy_to_prod_pipeline" {
  name        = "deploy-to-prod-pipeline"
  description = "Trigger for deployment to production"
  location    = var.region
  project     = var.cicd_runner_project_id

  repository_event_config {
    repository = "projects/${var.cicd_runner_project_id}/locations/${var.region}/connections/${var.host_connection_name}/repositories/${var.repository_name}"
  }

  filename = "deployment/cd/deploy-to-prod.yaml"

  substitutions = {
    _PROD_PROJECT_ID             = var.prod_project_id
    _REGION                      = var.region
    _ARTIFACT_REGISTRY_REPO_NAME = var.artifact_registry_repo_name
    _CLOUD_RUN_APP_SA_NAME      = var.cloud_run_app_sa_name
  }

  service_account = "projects/${var.cicd_runner_project_id}/serviceAccounts/${var.cicd_runner_sa_name}@${var.cicd_runner_project_id}.iam.gserviceaccount.com"

  approval_config {
    approval_required = true
  }
} 