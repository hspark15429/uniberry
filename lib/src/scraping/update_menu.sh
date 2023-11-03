#!/bin/bash
export GOOGLE_APPLICATION_CREDENTIALS="/Users/hanpark/development/keys/fir-flutter-codelab-39c7d-firebase-adminsdk-a25ao-1df95655ac.json"
python3 playwright_test/test_example.py && python3 menu.py