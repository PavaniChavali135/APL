//Writing a basic employee program
struct Employee {
    id: u32,
    name: String,
}

fn create_employees(num_employees: u32) -> Vec<Employee> {
    let mut employees: Vec<Employee> = Vec::new();
    for i in 0..num_employees {
        let employee = Employee {
            id: i,
            name: format!("Employee {}", i),
        };

        employees.push(employee);
    } // The 'employee' variable goes out of scope, but ownership has been moved.
    employees
} // The 'employees' vector is returned, transferring ownership to the caller.

fn main() {
    let mut team_a = create_employees(5);
    println!("Team A created with {} members.", team_a.len());

    // Borrowing: We can access `team_a` without taking ownership.
    let first_employee = &team_a[0];
    println!("First employee in Team A: {}", first_employee.name);

    // This loop takes ownership of each `Employee` struct.

    println!("Releasing Team A members...");
    for employee in team_a {
        // As each `employee` struct goes out of scope, its memory is freed.
        println!("  - Fired Employee {} ({})", employee.name, employee.id);
    }

    // The vector itself will be dropped at the end of `main` and memory for Employee dealocated
}
