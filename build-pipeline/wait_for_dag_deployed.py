import time

WAIT_TIME = 5 

def wait(wait_time:int) -> None:
    time.sleep(wait_time)
    print(f"Waited {wait_time} for so DAG can be updated")

if __name__ == "__main__":
    wait(WAIT_TIME)