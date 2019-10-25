//Author: Rivera, Andrei

use std::io;


fn main(){
	struct Subject {
		class_section:String,
		course_code:String

	}struct Student {
		name: String,
		s_num: String,
		subjects: Vec<Subject >
	}

	let s = (Subject{class_section:"first section".to_string(),course_code:"first course code".to_string()});
	let mut sample = vec![s];

	let t = (Student{name:"first name".to_string(),s_num:"first student number".to_string(),subjects:sample});
	let mut students = vec![t];

	let mut choice = 0;

	//This loops the menu until the user enters 7
	'outer: while choice!=5 {
		choice = printMenu();
		if choice == 1{	//ADD A STUDENT
			let mut student_name = String::new();
			let mut student_num = String::new();
			let mut new_student_num = String::new();
			let mut new_is_used = false;

			//Declares the student's subjectList
			let s = (Subject{class_section:"first section".to_string(),course_code:"first course code".to_string()});
			let mut subjectList = vec![s];

			println!("Enter Student's Name: ");
			io::stdin().read_line(&mut student_name);
			student_name.to_string();

			println!("Enter Student's Student Number: ");
			io::stdin().read_line(&mut student_num);
			student_num.to_string();

			if students.len() != 1 {
				for i in 1..students.len(){
					if(students[i].s_num == student_num){
						println!("This student number is already used. Pick another.");
						print!("This is the list of used student numbers:");
						for j in 1..students.len(){
							println!("{}", students[j].s_num);
						}

						println!("Enter New Student's Student Number: ");
						io::stdin().read_line(&mut new_student_num);
						new_student_num.to_string();

						new_is_used = true;
					}
				}
			}
			
			if new_is_used == true{
				student_num = new_student_num;
			}

			students.push(Student{name:student_name,s_num:student_num,subjects:subjectList});
		} else if choice == 2{	//VIEW ALL STUDENTS
			if students.len()==1 {
				println!("\nThere are no customers available to view. ");
				continue;
			}
			for i in 1..students.len(){
				println!("# {}",i);
				print!("Name: {}", students[i].name);
				print!("Student Number: {}", students[i].s_num);

				if students[i].subjects.len() == 1{
					println!("< No Listed Subjects >");
				}else{
					println!("<< Listed Subjects >>");
					for j in 1..students[i].subjects.len(){
						println!("Class #: {}", j);
						print!("Class Section: {}", students[i].subjects[j].class_section);
						print!("Course Code: {}", students[i].subjects[j].course_code)
					}
				}
				println!("== STUDENT # {} END ==", i);
			}
			println!("=== STUDENT RECORD END ===");
		} else if choice == 3{	//ADD A SUBJECT TO STUDENT
			let mut student_num = String::new();
			let mut section = String::new();
			let mut code = String::new();

			if students.len()==1 {
				println!("\nThe STUDENT RECORD is empty.");
				continue;
			} else {
				println!("\nEnter Student Number: ");
				io::stdin().read_line(&mut student_num);
				student_num.to_string();

				for i in 1..students.len(){
					if students[i].s_num == student_num {
						println!("\nEnter Class Section: ");
						io::stdin().read_line(&mut section);
						section.to_string();

						println!("\nEnter Class Code: ");
						io::stdin().read_line(&mut code);
						code.to_string();

						students[i].subjects.push((Subject{class_section:section,course_code:code}));

						break;
					}
					if i+1 == students.len() {
						println!("\nNo such student in the STUDENT RECORD.",);
					}
				}
			}
		} else if choice == 4{	//DELETE A STUDENT
			let mut s_num = String::new();

			if students.len()==1 {
				println!("\nThe STUDENT RECORD is empty");
				continue;
			}
			else {
				println!("\nEnter Student Number to delete: ");
				io::stdin().read_line(&mut s_num);
				s_num.to_string();
				for i in 1..students.len(){
					if students[i].s_num == s_num {
						students.remove(i);
						println!("\n Student deleted!");
						break;
					}
					if i+1 == students.len() {
						println!("\nThe student is not on the STUDENT RECORD.",);
					}
				}
			}
		}else { //This exits the program
			println!("Come Back Again!");
		}
	}

}

fn printMenu() -> i8{
	let mut x = String::new();
	print!("\n~MENU~\n[1] ADD A STUDENT\n[2] VIEW ALL STUDENTS\n[3] ADD A SUBJECT TO STUDENT\n[4] DELETE A STUDENT\n[5] EXIT\n\nEnter Choice:\n");
	io::stdin().read_line(&mut x);
	let x:i8 = x.trim().parse().expect("error");

	return x;
}
