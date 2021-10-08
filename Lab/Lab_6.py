import mysql.connector as sql

db = sql.connect(host="localhost", user="", password="", database="lab")

cursor = db.cursor()

cursor.execute(
    "CREATE TABLE IF NOT EXISTS passenger  (name VARCHAR(255) PRIMARY KEY, age INT, gender VARCHAR(255))"
)

cursor.execute(
    "CREATE TABLE IF NOT EXISTS reservation (seatno INT PRIMARY KEY, source VARCHAR(255), destination VARCHAR(255), name VARCHAR(255), FOREIGN KEY(name) REFERENCES passenger(name) ON DELETE CASCADE)"
)

def insert(seatno, name, age, gender, source, destination):
    sql1 = "INSERT INTO passenger VALUES (%s, %s, %s)"
    sql2 = "INSERT INTO reservation VALUES (%s, %s, %s, %s)"
    val1 = (name, age, gender)
    val2 = (seatno, source, destination, name)
    cursor.execute(sql1, val1)
    cursor.execute(sql2, val2)
    db.commit()

def find(name):
    sql = "SELECT * FROM passenger WHERE name=%s"
    cursor.execute(sql, (name,))
    passenger = cursor.fetchall()
    print(passenger)

def update(seatno, updated_destination):
    sql = "UPDATE reservation SET destination=%s WHERE seatno=%s"
    cursor.execute(sql, (updated_destination, seatno,))
    db.commit()

def delete_seat(seatno):
    sql = "DELETE FROM reservation WHERE seatno=%s"
    cursor.execute(sql, (seatno,))
    db.commit()

while True:
    action = input('Please enter what do you want to do:(insert/find/update/delete_seat): ')
    if action == 'insert':
        seatno = int(input("Seat no: "))
        name = input('Name: ')
        age = int(input('Age: '))
        gender = input('Gender: ')
        source = input('Source: ')
        destination = input('Destination: ')

        insert(seatno, name, age, gender, source, destination)
        print('Inserted to db sucessfully!!')

    elif action == 'find':
        name = input('Enter name: ')
        find(name)

    elif action == 'delete_seat':
        seatno = int(input('Seat no: '))
        delete_seat(seatno)
        print('Deleted successfully')
        
    elif action == 'update':
        seatno = int(input('Seatno: '))
        updated_destination = input('Updated destination: ')
        update(seatno, updated_destination)
        print('Updated succesfully!!')
    
    else:
        break