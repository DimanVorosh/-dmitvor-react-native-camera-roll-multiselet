import React, {useRef} from 'react';
import {Button, SafeAreaView, StyleSheet} from 'react-native';
import {GalleryView, GalleryViewHandle, MediaData} from './src';

function App(): React.JSX.Element {
  const onSelectPhoto = (photo: MediaData) => {
    console.log(photo, 'photo');
  };

  const galleryRef = useRef<GalleryViewHandle>(null);

  const handleGetSelected = async () => {
    if (galleryRef.current) {
      const selectedMedia = await galleryRef.current.getSelectedMedia();
      console.log('Selected Media:', selectedMedia);
    }
  };

  return (
    <SafeAreaView style={styles.container}>
      <Button title="Get Selected Media" onPress={handleGetSelected} />
      <GalleryView
        ref={galleryRef}
        style={styles.gallery}
        onSelectMedia={onSelectPhoto}
        isMultiSelectEnabled={false}
      />
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  gallery: {
    width: '100%',
    height: '100%',
  },
});

export default App;
