from datetime import timedelta
import firebase_admin
from firebase_admin import credentials, storage
import os


# Initialize Firebase
firebase_admin.initialize_app()

def fetch_url_from_storage(path):
    # Get a reference to the storage service
    bucket = storage.bucket('fir-flutter-codelab-39c7d.appspot.com')

    # Point to the specified path in your storage
    blob = bucket.blob(path)

    # Fetch the download URL
    url = blob.generate_signed_url(timedelta(days=365), method='GET')
    return url

def upload_to_storage(local_file_path, storage_file_path):
    bucket = storage.bucket('fir-flutter-codelab-39c7d.appspot.com')
    blob = bucket.blob(storage_file_path)
    blob.upload_from_filename(local_file_path)
    print(f'File {local_file_path} uploaded to {storage_file_path}.')

def delete_files_in_folder(folder_path):
    bucket = storage.bucket('fir-flutter-codelab-39c7d.appspot.com')
    
    # List all files in the specified folder
    blobs = bucket.list_blobs(prefix=folder_path)
    
    for blob in blobs:
        print(f"Deleting {blob.name}...")
        blob.delete()
        print(f"Deleted {blob.name}.")

    # delete local files
    target_folder = "assets/foodpics"
    for file_name in os.listdir(target_folder):
        file_path = os.path.join(target_folder, file_name)
        try:
            # Check if it's a file and then delete it
            if os.path.isfile(file_path):
                os.unlink(file_path)
                print(f"Deleted local file: {file_path}")
        except Exception as e:
            print(f"Error deleting {file_path}. Reason: {e}")

# # Test
# path = 'menu/pics/814354.png'
# print(fetch_url_from_storage(path))
