# Homework 2 Create a Load-Balanced Cluster with Auto Scaling
**กำหนดส่ง:** วันจันทร์ที่ 13 พฤศจิกายน 2560 เวลา 23.30น.
![alt text](https://image.slidesharecdn.com/005elasticityandmanagementtoolssjcole-161115000022/95/awsome-day-2016-module-5-aws-elasticity-and-management-tools-2-638.jpg?cb=1479168263)

**วัตถุประสงค์:** เพื่อให้น.ศ.ได้ฝึกปฏิบัติทักษะที่ต้องใช้ในการทำ Horizontal Scaling สำหรับ Application Server 

**ลักษณะงาน:** งานเดี่ยว

**คำอธิบายงานที่มอบหมาย:**
1. สร้าง Amazon Machine Image (AMI) ของ CRUD Application ที่น.ศ.พัฒนาขึ้นใน Homework 1 หรือ Web application อื่นตามที่น.ศ.เห็นเหมาะสม
2. สร้าง Application Load Balancer จาก EC2 Dashboard กำหนดให้ Load balancer คอยฟัง connection HTTP request ที่เข้ามายัง port 80 
3. สร้าง Launch configuration โดยให้ใช้ AMI ที่สร้างไว้ในข้อที่ 1. พร้อมทั้ง Enable CloudWatch monitoring บน instance ที่จะ launch จาก configuration นี้ด้วย
4. สร้าง Auto Scaling Group ให้มีจำนวนเริ่มต้น 2 instances และให้รับ traffic จาก Target group ของ Load balancer ที่สร้างไว้ในข้อ 2.
5. ให้ Auto Scaling Group ในข้อ 4. ปรับจำนวน instance ใน Group ตั้งแต่ 2 ถึง 10 instances ตาม Scaling Policies ดังต่อไปนี้
* Increase Group Size ให้เพิ่ม 1 instance เมื่อ average CPU Utilization >= 70% ต่อเนื่องกันอย่างน้อย 1 นาที ตั้ง Alarm ด้วย (ตั้งเวลา warm up 60s)
* Decrease Group Size ให้ลด 1 instance เมื่อ average CPU Utilization <= 20% ต่อเนื่องกันอย่างน้อย 1 นาที ตั้ง Alarm ด้วย 
6. ทดสอบการทำงานของ Autoscaling โดยใช้ Load Test Feature ของ AWS หรือใช้ tools อื่นๆ เช่น ApacheBench, Siege หรือ Locust.io
7. อัดคลิปวีดีโอที่กระชับและได้ใจความ (ไม่ควรเกิน 30 นาที) อธิบายหรือแสดงวิธีการทำขั้นตอนที่ 1-5 พอสังเขป และ demo การทำงานของ Load balancer และ Autoscaling group ว่าสามารถใช้ปรับจำนวน Server ใน Account ของตนเองได้จริง
8. Extra Credit 30% สำหรับน.ศ.ที่ใช้ AWS SDK หรือ Terraform เขียนสคริปต์ automate ขั้นตอนในข้อ 3.-5. (ขั้นตอนละ 10%)
5. ส่งคลิปวีดีโอ และไฟล์ที่เกี่ยวข้องทั้งหมด (กรณีที่ทำ extra credit) ที่ HW2 Individual Repo ของนักศึกษาเอง

**เกณฑ์การตรวจคลิปวีดีโอ:**
* AMI 10%
* Setup process 2. to 5. 50%
* Scaling demo 40% (แบ่งเป็นวิธีการ Deploy 10%, เริ่มการท างานของ instance และ hardware ที่ใช้ 5%, demo 40%)

**แหล่งอ้างอิง:**
* http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/creating-an-ami-ebs.html
* http://docs.aws.amazon.com/elasticloadbalancing/latest/application/application-load-balancer-getting-started.html
* http://docs.aws.amazon.com/autoscaling/latest/userguide/LaunchConfiguration.html
* http://docs.aws.amazon.com/autoscaling/latest/userguide/as-register-lbs-with-asg.html
* http://www.cardinalpath.com/autoscaling-your-website-with-amazon-web-services-part-2/
* http://www.theodo.fr/blog/2016/04/autoscaling-with-aws-2/
* https://davidwzhang.com/2017/04/04/use-terraform-to-set-up-aws-auto-scaling-group-with-elb/

Grading Results
================
[Link to Google Sheet]()
