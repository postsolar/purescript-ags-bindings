// Don't use AGS implementation because it swallows all errors.
export const readFileImpl =
  f =>
    { const [, bytes] = f.load_contents(null);
      return new TextDecoder().decode(bytes);
    }

export const readFileAsyncImpl =
  Utils.readFileAsync

// Wrap AGS implementation to work on GioFiles instead of strings
export const writeFileImpl = (content, file) =>
  Utils.writeFile(content, file.get_path())

// Wrap AGS implementation to work on GioFiles instead of strings
export const writeFileSyncImpl = (content, file) =>
  Utils.writeFileSync(content, file.get_path())

