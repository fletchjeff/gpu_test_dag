import json
from datetime import datetime, timedelta
from airflow.decorators import dag, task 

@dag(
    schedule_interval=None,
    start_date=datetime(2022, 9, 15),
    catchup=False,
    default_args={
        "retries": 2, 
    },
    tags=['GPU Test DAG']) 
def gpu_test_dag():

    @task(queue='non_gpu_worker')
    def run_in_non_gpu_worker():
        """
        Loads Tensorflow and shows if there is an active GPU.

        """
        import tensorflow as tf
        GPU_name = tf.test.gpu_device_name()
        if GPU_name != "":
            print(GPU_name)
            return GPU_name
        else:
            print("No GPU!!")
            return "No GPU!!"            

    @task(queue='gpu_worker') 
    def run_in_gpu_worker(non_gpu_result):
        """
        Loads Tensorflow and shows if there is an active GPU.

        """        
        import tensorflow as tf
        GPU_name = tf.test.gpu_device_name()
        if GPU_name != "":
            print(GPU_name)
            return GPU_name
        else:
            print("No GPU!!")
            return "No GPU!!"     

    @task(queue='gpu_worker')
    def run_ai_benchmark(gpu_result):
        """
        Runs the AI Benchmark to see the perfomance of the GPU

        """     
        from ai_benchmark import AIBenchmark
        benchmark = AIBenchmark()
        results = benchmark.run()
        print(results)
        return results

    non_gpu_test = run_in_non_gpu_worker()
    gpu_test = run_in_gpu_worker(non_gpu_test)
    gpu_test_results = run_ai_benchmark(gpu_test)

gpu_test_dag_run = gpu_test_dag()