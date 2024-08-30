<script>
  import ForBusinessesTab from "./ForBusinessesTab.svelte";
  import ForIndividualsTab from "./ForIndividualsTab.svelte";

  let tabs = [
    { name: "For Individuals", comp: ForIndividualsTab },
    { name: "For Businesses", comp: ForBusinessesTab },
  ];
  let cur = tabs[0];
</script>

<div class="flex justify-center mb-4 space-x-2">
  {#each tabs as tab}
    <button
      on:click={() => (cur = tab)}
      class="px-4 py-2 text-sm font-medium text-white bg-blue-600 rounded-md transition duration-150 ease-in-out hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
      class:bg-blue-800={cur === tab}
    >
      {tab.name}
    </button>
  {/each}
</div>

<main>
  <svelte:component this={cur.comp} />
</main>
