# Your Production Google Cloud project id
prod_project_id = "my-prod-sincere-baton-418601"
staging_project_id = my-staging-sincere-baton-418601"
cicd_runner_project_id = "my-cicd-sincere-baton-418601"
host_connection_name = "test3"
repository_name = "Dragaris-test2"
region = "us-central1"

telemetry_bigquery_dataset_id = "telemetry_genai_app_sample_sink"
telemetry_sink_name = "telemetry_logs_genai_app_sample"
telemetry_logs_filter = "jsonPayload.attributes.\"traceloop.association.properties.log_type\"=\"tracing\" jsonPayload.resource.attributes.\"service.name\"=\"Sample Chatbot Application\""

feedback_bigquery_dataset_id = "feedback_genai_app_sample_sink"
feedback_sink_name = "feedback_logs_genai_app_sample"
feedback_logs_filter = "jsonPayload.log_type=\"feedback\""

cloud_run_app_sa_name = "genai-app-sample-cr-sa"