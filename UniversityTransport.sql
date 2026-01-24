USE UniversityTransport;
GO


--  جدول الطلاب
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name NVARCHAR(100),
    university_id VARCHAR(10),
    email NVARCHAR(100),
    phone_number VARCHAR(20),
    district_id INT
);

-- جدول المركبات

CREATE TABLE Vehicles (
    vehicle_id INT PRIMARY KEY,
    vehicle_type NVARCHAR(50),
    plate_number_ar NVARCHAR(10),
    plate_number_en NVARCHAR(10),
    seats INT,
    status NVARCHAR(20)
);

-- جدول السائقين
CREATE TABLE Drivers (
    driver_id INT PRIMARY KEY,
    driver_name NVARCHAR(100),
    employee_number VARCHAR(10),
    phone_number NVARCHAR(20)
);

-- جدول الاحياء 
CREATE TABLE Districts (
    district_id INT PRIMARY KEY,
    district_name NVARCHAR(100),
    gathering_point NVARCHAR(100)
);

-- جدول الاشتراكات
CREATE TABLE Subscriptions (
    subscription_id INT PRIMARY KEY,
    student_id INT,
    district_id INT,
    start_date DATE,
    end_date DATE,
    status NVARCHAR(20),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (district_id) REFERENCES Districts(district_id)
);

-- البلاغات الطارئة

CREATE TABLE Emergencies (
    report_id INT PRIMARY KEY,
    driver_id INT,
    vehicle_id INT,
    district_id INT,
    report_date DATE,
    report_time TIME,
    reason NVARCHAR(255),
    status NVARCHAR(50),
    action_taken NVARCHAR(255),
    FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id),
    FOREIGN KEY (district_id) REFERENCES Districts(district_id)
);

-- جدول ربط السائق بالمركبة
CREATE TABLE DriverVehicle (
    id INT PRIMARY KEY,
    driver_id INT,
    vehicle_id INT,
    FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id)
);


-- ربط المركبة بالحي 

CREATE TABLE VehicleDistricts (
    id INT PRIMARY KEY,
    vehicle_id INT,
    district_id INT,
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id),
    FOREIGN KEY (district_id) REFERENCES Districts(district_id)
);




-- بيانات الطلاب

INSERT INTO Students VALUES
(1, 'عبدالرحمن', '442001801', 'abdulrahman@ut.edu.sa', '0512300001', 1),
(2, 'سلمان', '451101202', 'salman@ut.edu.sa', '0540000002', 2),
(3, 'عبدالله', '461001903', 'abdullah@ut.edu.sa', '0540000003', 1);

-- بيانات الاحياء

INSERT INTO Districts VALUES
(1, 'حي مروج الامير' , NULL),
(2, 'حي المصيف', NULL),
(3, 'حي الدخل', NULL);

-- بيانات الباصات 

INSERT INTO Vehicles VALUES
(1, 'باص 1', 'د ب ل 1234', N'LBD 1234', 10, 'نشط'),
(2, 'باص 2', 'س ط و 5678', N'STW 5678', 20, 'نشط'),
(3, 'باص 3', 'ف ق ن 9999', 'FQN 9999', 15, N'نشط');



-- بيانات السائقين 

INSERT INTO Drivers VALUES
(1, 'أحمد ', 'D001', '0551234567'),
(2, 'سعيد ', 'D002', '0552345678'),
(3, 'سعود', 'D003', '0553456789');


-- بيانات الاشتراكات

INSERT INTO Subscriptions VALUES
(1, 1, 1, '2025-09-01', '2026-01-01', N'مشترك'),
(2, 2, 2, '2025-09-01', '2026-01-01', N'مشترك'),
(3, 3, 1, '2025-09-01', '2026-01-01', N'مشترك');

-- بيانات ربط كل سائق بالباص
INSERT INTO DriverVehicle VALUES
(1, 1, 1),  -- أحمد يقود باص 1
(2, 2, 2),  -- سعيد يقود باص 2
(3, 3, 3);  -- سعود يقود باص 3



-- بيانات ربط الباصات بالاحياء
INSERT INTO VehicleDistricts (id, vehicle_id, district_id) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 2, 3);


INSERT INTO Emergencies VALUES
(1, 3, 3, 3, '2025-10-01', '07:30:00', N'عطل في المحرك', N'جاري المتابعة', N'تم إرسال ورشة الصيانة');




-- استعلامات 

-- استعلام يظهر هل الطالب مشترك في الباص

SELECT 
    s.student_id,
    s.student_name,
    s.university_id,
    s.email,
    s.phone_number,
    CASE 
        WHEN sub.subscription_id IS NOT NULL THEN N'مشترك'
        ELSE N'غير مشترك'
    END AS subscription_status
FROM Students s
LEFT JOIN Subscriptions sub ON s.student_id = sub.student_id;


-- استعلام يظهر معلومات الطالب والحي الساكن فيه والباص 

SELECT 
    s.student_id,
    s.student_name,
    d.district_name,
    v.vehicle_id,
    v.vehicle_type,
    v.plate_number_ar,
    v.plate_number_en
FROM Students s
JOIN Districts d ON s.district_id = d.district_id
LEFT JOIN VehicleDistricts vd ON d.district_id = vd.district_id
LEFT JOIN Vehicles v ON vd.vehicle_id = v.vehicle_id;


-- معلومات السائقين ومركباتهم

SELECT 
    d.driver_id,
    d.driver_name,
    d.employee_number,
    d.phone_number,
    v.vehicle_id,
    v.vehicle_type,
    v.plate_number_ar,
    v.plate_number_en
FROM Drivers d
LEFT JOIN DriverVehicle dv ON d.driver_id = dv.driver_id
LEFT JOIN Vehicles v ON dv.vehicle_id = v.vehicle_id;


-- استعلام يظهر حالات الطوارئ 

SELECT 
    e.report_id,
    d.driver_name,
    v.vehicle_type,
    v.plate_number_ar,
    dis.district_name,
    e.report_date,
    e.report_time,
    e.reason,
    e.status,
    e.action_taken
FROM Emergencies e
JOIN Drivers d ON e.driver_id = d.driver_id
JOIN Vehicles v ON e.vehicle_id = v.vehicle_id
JOIN Districts dis ON e.district_id = dis.district_id;








