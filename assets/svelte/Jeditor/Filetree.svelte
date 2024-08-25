<script>
  import { Wunderbaum } from "wunderbaum";
  import { onMount } from "svelte";
  import { activeFile, dirScope } from "./stores/justboxes";

  import { Icon, DocumentPlus, FolderPlus, ArrowPath } from "svelte-hero-icons";

  export let live;
  export let justbox_name;
  export let s3_keys;
  let treeContainer;

  function createTreeFromPaths(paths) {
    const root = { title: "Root", folder: true, children: [] };

    paths.forEach((path) => {
      const parts = path.split("/");
      let currentNode = root;
      let currentPath = "";

      parts.forEach((part, index) => {
        currentPath += (index === 0 ? "" : "/") + part;
        let existingNode = currentNode.children.find(
          (child) => child.title === part
        );

        if (!existingNode) {
          const newNode = {
            title: part,
            folder: index < parts.length - 1,
            children: [],
            path: currentPath,
          };
          currentNode.children.push(newNode);
          existingNode = newNode;
        }

        currentNode = existingNode;
      });
    });

    return [root];
  }

  function refreshExplorer() {
    live.pushEvent("refresh_explorer", {
      handle: user_handle,
      justbox_slug: "test",
    });
  }

  function newFile() {
    live.pushEvent("new_file", {
      handle: user_handle,
      file_s3_key: dirScope + "file",
    });
  }

  function newFolder() {
    live.pushEvent("new_folder", {
      handle: user_handle,
    });
  }

  function openFile(s3_key) {
    activeFile.set(s3_key);
    live.pushEvent("fetch_file", { s3_key: s3_key });
  }

  let treeData = [];

  onMount(() => {
    treeData = createTreeFromPaths(s3_keys);
    let currentUrl = window.location.pathname;
    let urlParts = currentUrl.split("/").filter(Boolean);
    user_handle = urlParts[0];
    const tree = new Wunderbaum({
      element: treeContainer,
      source: treeData,
      click: (e) => {
        if (!e.node.data.folder) {
          openFile(e.node);
        }
      },
    });
  });
</script>

{#if s3_keys === null}
  <div class="text-center">
    <h2 class="text-xl font-medium text-center">Error</h2>
    <p>Failed to fetch files names</p>
  </div>
{:else}
  <div class="pr-2 w-full h-full truncate border-r-2 border-neutral-300">
    <div
      class="flex justify-between p-1 text-sm font-medium text-white bg-blue-500 rounded-t"
    >
      <h2>{justbox_name}</h2>
      <div class="flex items-center space-x-1">
        <button
          class="hover:bg-blue-400"
          title="Refresh explorer"
          on:click={refreshExplorer}
        >
          <Icon src={ArrowPath} size="20" />
        </button>
        <button class="hover:bg-blue-400" title="New File" on:click={newFile}>
          <Icon src={DocumentPlus} size="20" />
        </button>
        <button
          class="hover:bg-blue-400"
          title="New Folder"
          on:click={newFolder}
        >
          <Icon src={FolderPlus} size="20" />
        </button>
      </div>
    </div>
    <div bind:this={treeContainer}></div>
  </div>
{/if}
