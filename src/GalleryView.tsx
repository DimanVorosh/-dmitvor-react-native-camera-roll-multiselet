import React, {forwardRef, useImperativeHandle, useRef} from 'react';
import {requireNativeComponent} from 'react-native';
import {
  NativeViewProps,
  GalleryViewProps,
  MediaData,
  GalleryViewHandle,
} from './types';
import {getSelectedMedia} from './utils/getSelectedMedia';

const NativeGalleryView =
  requireNativeComponent<NativeViewProps>('GalleryView');

const GalleryView = forwardRef<GalleryViewHandle, GalleryViewProps>(
  (
    {
      style,
      onSelectMedia,
      isMultiSelectEnabled = false,
      multiSelectStyle = {mainColor: 'white', subColor: 'blue'},
    },
    ref,
  ) => {
    const galleryRef = useRef(null);

    useImperativeHandle(ref, () => ({
      getSelectedMedia: async () => {
        return await getSelectedMedia(galleryRef);
      },
    }));

    const handleSelectMedia = (event: {nativeEvent: MediaData}) => {
      const media = event.nativeEvent;

      onSelectMedia && onSelectMedia(media);
    };

    return (
      <NativeGalleryView
        style={style}
        onSelectMedia={handleSelectMedia}
        isMultiSelectEnabled={isMultiSelectEnabled}
        multiSelectStyle={multiSelectStyle}
        ref={galleryRef}
      />
    );
  },
);

export default GalleryView;
