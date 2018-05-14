web: bundle exec puma -t ${WEB_THREADS_MIN:-8}:${WEB_THREADS_MAX:-12} -w ${WEB_PROCESSES:-2} -p $PORT -e ${RACK_ENV:-development}
