<script>
  import { onMount } from "svelte";

  export let recommendedValue;
  export let vCPUs;
  export let ram;
  export let storage;

  function updateRecommended() {
    vCPUs = Math.round(recommendedValue / 25) + 1;
    ram = Math.round(recommendedValue / 25);
    storage = Math.round(recommendedValue);
  }

  function mvcpu() {
    vCPUs -= 1;
  }
  function pvcpu() {
    vCPUs += 1;
  }
  function mram() {
    ram -= 1;
  }
  function pram() {
    ram += 1;
  }
  function mstorage() {
    storage -= 1;
  }
  function pstorage() {
    storage += 1;
  }

  onMount(() => {
    updateRecommended();
  });
</script>

<div class="flex flex-col p-6 mx-auto">
  <div class="mb-6">
    <input
      type="range"
      id="recommended"
      bind:value={recommendedValue}
      min="0"
      max="100"
      step="1"
      on:input={updateRecommended}
      class="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer"
    />
  </div>

  <div class="flex space-x-12">
    <div>
      <label for="vcpus" class="block mb-1 text-sm font-medium">vCPUs</label>
      <div class="flex items-center h-24">
        <input
          type="number"
          id="vcpus"
          bind:value={vCPUs}
          min="1"
          max="32"
          class="p-8 text-3xl font-bold rounded-l-md border-zinc-500 h-full border [appearance:textfield] [&::-webkit-outer-spin-button]:appearance-none [&::-webkit-inner-spin-button]:appearance-none"
        />
        <div class="flex flex-col justify-between h-full text-xl">
          <button
            class="px-4 py-2 h-full font-bold rounded-tr border-t border-r border-zinc-500 hover:bg-zinc-200"
            on:click={pvcpu}>+</button
          >
          <button
            class="px-4 py-2 h-full font-bold rounded-br border-t border-r border-b border-zinc-500 hover:bg-zinc-200"
            on:click={mvcpu}>-</button
          >
        </div>
      </div>
    </div>
    <div>
      <label for="vcpus" class="block mb-1 text-sm font-medium"
        >RAM (in GBs)</label
      >
      <div class="flex items-center h-24">
        <input
          type="number"
          id="vcpus"
          bind:value={ram}
          min="1"
          max="32"
          class="p-8 text-3xl font-bold rounded-l-md border-zinc-500 h-full border [appearance:textfield] [&::-webkit-outer-spin-button]:appearance-none [&::-webkit-inner-spin-button]:appearance-none"
        />
        <div class="flex flex-col justify-between h-full text-xl">
          <button
            class="px-4 py-2 h-full font-bold rounded-tr border-t border-r border-zinc-500 hover:bg-zinc-200"
            on:click={pram}>+</button
          >
          <button
            class="px-4 py-2 h-full font-bold rounded-br border-t border-r border-b border-zinc-500 hover:bg-zinc-200"
            on:click={mram}>-</button
          >
        </div>
      </div>
    </div>
    <div>
      <label for="vcpus" class="block mb-1 text-sm font-medium"
        >Storage (In GBs)</label
      >
      <div class="flex items-center h-24">
        <input
          type="number"
          id="vcpus"
          bind:value={storage}
          min="1"
          max="32"
          class="p-8 text-3xl font-bold rounded-l-md border-zinc-500 h-full border [appearance:textfield] [&::-webkit-outer-spin-button]:appearance-none [&::-webkit-inner-spin-button]:appearance-none"
        />
        <div class="flex flex-col justify-between h-full text-xl">
          <button
            class="px-4 py-2 h-full font-bold rounded-tr border-t border-r border-zinc-500 hover:bg-zinc-200"
            on:click={pstorage}>+</button
          >
          <button
            class="px-4 py-2 h-full font-bold rounded-br border-t border-r border-b border-zinc-500 hover:bg-zinc-200"
            on:click={mstorage}>-</button
          >
        </div>
      </div>
    </div>
    <div
      class="p-2 mt-auto w-full h-24 bg-gradient-to-r from-blue-500 to-blue-600 rounded-md"
    >
      <p class="font-semibold text-white">Price</p>
      <p class="text-5xl font-black text-white">7$</p>
    </div>
  </div>
  <button
    class="p-4 mx-auto mt-8 font-semibold text-white bg-blue-500 rounded-lg shadow-lg transition-transform transform hover:scale-105 hover:shadow-xl active:shadow-inner"
  >
    Just Try It
  </button>
  <p class="mx-auto text-sm text-gray-700">No credit card required</p>
</div>

<style>
  input[type="range"] {
    -webkit-appearance: none;
    appearance: none;
    width: 100%;
    height: 25px;
    background: transparent;
    outline: none;
    opacity: 0.7;
    transition: opacity 0.2s;
  }

  input[type="range"]:hover {
    opacity: 1;
  }

  input[type="range"]::-webkit-slider-runnable-track {
    width: 100%;
    height: 25px;
    cursor: pointer;
    background: linear-gradient(to bottom, #f0f0f0, #ffffff, #f0f0f0);
    border-radius: 25px;
    border: 2px solid #e0e0e0;
    box-shadow:
      0 4px 6px -1px rgba(0, 0, 0, 0.1),
      0 2px 4px -1px rgba(0, 0, 0, 0.06);
  }

  input[type="range"]::-webkit-slider-thumb {
    -webkit-appearance: none;
    appearance: none;
    width: 35px;
    height: 35px;
    background: white;
    cursor: pointer;
    border-radius: 50%;
    border: 2px solid #3b82f6;
    margin-top: -7px;
    box-shadow:
      0 0 10px 2px rgba(59, 130, 246, 0.3),
      0 0 0 4px rgba(59, 130, 246, 0.1);
    transition: all 0.2s ease-in-out;
  }

  input[type="range"]::-webkit-slider-thumb:hover {
    box-shadow:
      0 0 15px 3px rgba(59, 130, 246, 0.4),
      0 0 0 6px rgba(59, 130, 246, 0.2);
  }

  input[type="range"]::-moz-range-track {
    width: 100%;
    height: 25px;
    cursor: pointer;
    background: linear-gradient(to bottom, #f0f0f0, #ffffff, #f0f0f0);
    border-radius: 25px;
    border: 2px solid #e0e0e0;
    box-shadow:
      0 4px 6px -1px rgba(0, 0, 0, 0.1),
      0 2px 4px -1px rgba(0, 0, 0, 0.06);
  }

  input[type="range"]::-moz-range-thumb {
    width: 35px;
    height: 35px;
    background: white;
    cursor: pointer;
    border-radius: 50%;
    border: 2px solid #3b82f6;
    box-shadow:
      0 0 10px 2px rgba(59, 130, 246, 0.3),
      0 0 0 4px rgba(59, 130, 246, 0.1);
    transition: all 0.2s ease-in-out;
  }

  input[type="range"]::-moz-range-thumb:hover {
    box-shadow:
      0 0 15px 3px rgba(59, 130, 246, 0.4),
      0 0 0 6px rgba(59, 130, 246, 0.2);
  }
</style>
