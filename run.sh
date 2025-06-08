#!/bin/bash

echo "Compiling Java files..."

# Create target directory if it doesn't exist
mkdir -p target/classes

# Compile Java files
CLASSPATH=""
for jar in lib/*.jar; do
  CLASSPATH="$CLASSPATH:$jar"
done

echo "Using classpath: $CLASSPATH"

# Compile all Java files
find src/main/java -name "*.java" -print | xargs javac -d target/classes -cp "$CLASSPATH"

if [ $? -ne 0 ]; then
  echo "Compilation failed."
  exit 1
fi

echo "Compilation successful."

# Run the StaticServer
echo "Starting the QuickHire server..."
java -cp "target/classes:$CLASSPATH" com.quickhire.StaticServer
#!/bin/bash

echo "Compiling Java files..."

# Create target directory if it doesn't exist
mkdir -p target/classes

# Compile Java files
CLASSPATH=""
for jar in lib/*.jar; do
  CLASSPATH="$CLASSPATH:$jar"
done

echo "Using classpath: $CLASSPATH"

# Compile all Java files
find src/main/java -name "*.java" -print | xargs javac -d target/classes -cp "$CLASSPATH"

if [ $? -ne 0 ]; then
  echo "Compilation failed."
  exit 1
fi

echo "Compilation successful."

# Run the StaticServer
echo "Starting the QuickHire server..."
java -cp "target/classes:$CLASSPATH" com.quickhire.StaticServer