from locust import HttpLocust, TaskSet

def login(l):
    l.client.get("Your link path")

class UserBehavior(TaskSet):
    tasks = {login: 1}
    
    def on_start(self):
        login(self)

class WebsiteUser(HttpLocust):
    task_set = UserBehavior
    min_wait = 0
    max_wait = 0