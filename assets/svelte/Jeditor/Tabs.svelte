<script>
  function getFileName(path) {
    return path.split("/").pop().split("\\").pop();
  }
  function addTab(s3_key) {
    const tab = document.createElement("button");
    tab.setAttribute("data-s3-key", s3_key);
    tab.addEventListener("click", openFile());
    tab.textContent = getFileName(s3_key);
    tab.className = "pb-2 px-2 mb-2 border-b-2 border-blue-500";

    document.getElementById("tabs").appendChild(tab);
  }
</script>
