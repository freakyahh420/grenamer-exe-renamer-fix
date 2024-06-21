import os

def rename_exe_files(directory):
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.startswith('g') and file.endswith('.exe'):
                original_name = file[1:]  # Remove the leading 'g'
                exe_path = os.path.join(root, file)
                ico_path = os.path.join(root, 'g' + original_name[:-4] + '.ico')  # Remove .exe and add .ico

                if os.path.exists(ico_path):
                    new_exe_path = os.path.join(root, original_name)
                    try:
                        if os.path.exists(new_exe_path):
                            os.remove(new_exe_path)
                        os.rename(exe_path, new_exe_path)
                        os.remove(ico_path)
                        print("Renamed: {} to {} and deleted {}".format(exe_path, new_exe_path, ico_path))
                    except Exception as e:  # General exception for both PermissionError and FileExistsError
                        print("Error: {}. Skipping file: {}".format(e, exe_path))

def list_exe_files(directory, output_file):
    with open(output_file, 'w') as f:
        for root, dirs, files in os.walk(directory):
            for file in files:
                if file.startswith('g') and file.endswith('.exe'):
                    exe_path = os.path.join(root, file)
                    f.write(exe_path + '\n')
                    print("{}".format(exe_path))

def rename_files_from_list(file_list_path):
    if not os.path.exists(file_list_path):
        print("File {} does not exist. Please list the files with option number 2 first.".format(file_list_path))
        return

    with open(file_list_path, 'r') as f:
        lines = f.readlines()
        for line in lines:
            exe_path = line.strip()
            directory, file = os.path.split(exe_path)
            if file.startswith('g') and file.endswith('.exe'):
                original_name = file[1:]  # Remove the leading 'g'
                new_exe_path = os.path.join(directory, original_name)
                try:
                    if os.path.exists(new_exe_path):
                        os.remove(new_exe_path)
                    os.rename(exe_path, new_exe_path)
                    print("Renamed: {} to {}".format(exe_path, new_exe_path))
                except Exception as e:  # General exception for both PermissionError and other issues
                    print("Error: {}. Skipping file: {}".format(e, exe_path))

def main():
    while True:
        print("==========")
        print("Trojan.Renamer/GRenam Executable File Batch Renamer")
        print("Please run this script with escalated administrator privilege!")
        print("==========")
        print("This script purpose is to rename back executable files to filename.exe")
        print("that got renamed into g(filename).exe by the trojan.")
        print("Before running this, please make sure the trojan is absolutely nonexistent from the system")
        print("and the trojan version that you have is non-malicious to the renamed .exe files.")
        print("==========")
        print("Choose an option:")
        print("1. Fix renamed file with g(filename).exe pattern and has g(filename).ico in the same folder")
        print("2. List .exe files and save to output_file.txt")
        print("3. Rename files from output_file.txt")
        print("4. Quit")
        
        try:
            choice = raw_input("Enter your choice (1/2/3/4): ")
        except NameError:
            choice = input("Enter your choice (1/2/3/4): ")  # Python 3.x compatibility
        
        if choice == '1':
            try:
                directory_to_scan = raw_input("Enter the directory to scan (e.g., C:\\) (default: C:\\): ")
            except NameError:
                directory_to_scan = input("Enter the directory to scan (e.g., C:\\) (default: C:\\): ")  # Python 3.x compatibility
            
            if not directory_to_scan.strip():
                directory_to_scan = "C:\\"
            rename_exe_files(directory_to_scan)
            print("Scan completed.")
        elif choice == '2':
            try:
                directory_to_scan = raw_input("Enter the directory to scan (e.g., C:\\) (default: C:\\): ")
            except NameError:
                directory_to_scan = input("Enter the directory to scan (e.g., C:\\) (default: C:\\): ")  # Python 3.x compatibility
            
            if not directory_to_scan.strip():
                directory_to_scan = "C:\\"
            current_directory = os.getcwd()  # Get the current directory
            output_file = os.path.join(current_directory, "output_file.txt")  # Set the output file path
            list_exe_files(directory_to_scan, output_file)
            print("BEFORE PUTTING THE LIST BACK TO OPTION NUMBER 3, PLEASE MAKE SURE FILES LISTED ON output_file.txt IS ACTUALLY RENAMED AND NOT LEGIT FILES STARTED WITH g!")
            print("YOU HAVE TO CHECK THIS MANUALLY BY LOOKING THE FILE NAME ON GOOGLE / OPEN ITS PROPERTIES TO CHECK ACCESS TIME WHETHER ITS AROUND THE TROJAN RUNNING OR NOT / GO TO DETAILS TAB AND CHECK ORIGINAL FILENAME!!")
        elif choice == '3':
            try:
                file_list_path = raw_input("Enter file name in current directory (e.g., output_file.txt) (default: output_file.txt): ")
            except NameError:
                file_list_path = input("Enter file name in current directory (e.g., output_file.txt) (default: output_file.txt): ")  # Python 3.x compatibility
            
            if not file_list_path.strip():
                file_list_path = "output_file.txt"  # Path to the file containing the list of files to rename
            rename_files_from_list(file_list_path)
        elif choice == '4':
            print("Quitting the script.")
            break
        else:
            print("Invalid choice. Please try again.")

if __name__ == "__main__":
    main()