# Set variables for file paths
OUTPUT_DIR="/home/ahad/codes/logs"   # Replace with your desired directory

mkdir -p "$OUTPUT_DIR"

# Generate timestamp
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
FILE_NAME="life_message_${TIMESTAMP}.txt"
GZIP_NAME="life_message_${TIMESTAMP}.txt.gz"

# Create the text file
echo "This is a message about life: Stay positive, keep learning!" > "$OUTPUT_DIR/$FILE_NAME"

# Compress the file using gzip
gzip "$OUTPUT_DIR/$FILE_NAME"

# Confirm completion
echo "Message has been saved and compressed into $GZIP_NAME in $OUTPUT_DIR"
