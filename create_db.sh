until [ "$(gcloud sql instances describe postgres --format='value(state)')" == "RUNNABLE" ]; do
  echo "Waiting for Cloud SQL instance to be ready..."
  sleep 10
done

gcloud sql databases create fruitsdb --instance=postgres