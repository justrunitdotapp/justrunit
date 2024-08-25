import { writable } from "svelte/store";

export const fileTree = writable([]);
export const fetchedFiles = writable([]);
export const openFiles = writable([]);
export const activeFile = writable(null);
export const dirScope = writable(null);

function addFetched(new_file) {
  fetchedFiles.update((currentItems) => [...currentItems, new_file]);
}

function addOpen(new_file) {
  fetchedFiles.update((currentItems) => [...currentItems, new_file]);
}

function setActiveFile(file) {
  activeFile.update((activeFile) => file);
}
