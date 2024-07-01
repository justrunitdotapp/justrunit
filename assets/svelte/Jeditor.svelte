<script>
    // Initialize the counter state
    let count = 0;
  
    // Function to increment the counter
    function increment() {
      count += 1;
    }
  </script>
  
  <button on:click={increment}>Increment</button>
  <p>Count: {count}</p>