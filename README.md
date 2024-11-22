# Camera Roll with Multiselect

A customizable gallery view for React Native with multi-select support. Built with Swift for iOS.

## Installation

To install the library, run the following command:

```bash
npm i react-native-camera-roll-multiselect
```

## Props

| Prop                    | Type                                            | Default  | Description                                                   |
|-------------------------|-------------------------------------------------|----------|---------------------------------------------------------------|
| `style`                 | `ViewStyle`                                    | —        | Custom styles for the gallery view container.                 |
| `isMultiSelectEnabled`  | `boolean`                                       | `false`  | Enable or disable multi-select functionality.                 |
| `multiSelectStyle`      | `{ mainColor: string; subColor: string }`       | —        | Customize colors for multi-select UI (circle and background). |
| `onSelectMedia`         | `(media: MediaData) => void`                    | —        | Callback when a media item is selected.                       |


## Methods

### `getSelectedMedia`

```typescript
async getSelectedMedia(): Promise<MediaData[]>
```

Description: Returns a list of selected media objects.
Returns: A promise that resolves with an array of MediaData objects representing the selected media.

### `Usage:`
```typescript
const selectedMedia = await galleryRef.current.getSelectedMedia();
```

## Full Example:

```tsx
import React, { useRef } from 'react';
import { GalleryView } from 'react-native-camera-roll-multiselect';

const App = () => {
  const galleryRef = useRef(null);

  const handleSelectMedia = (media) => {
    console.log(media);
  };

  const handleGetSelectedMedia = async () => {
    const selectedMedia = await galleryRef.current.getSelectedMedia();
    console.log(selectedMedia);
  };

  return (
    <>
      <Button title="Get Selected Media" onPress={handleGetSelectedMedia} />
      <GalleryView
        ref={galleryRef}
        style={{ flex: 1 }}
        onSelectMedia={handleSelectMedia}
        isMultiSelectEnabled={true}
        multiSelectStyle={{
          mainColor: 'blue',
          subColor: 'green',
        }}
      />
    </>
  );
};
```