import {ViewStyle, NativeSyntheticEvent} from 'react-native';

export type MediaData = {
  id: string;
  creationDate: number;
  imageURL: string;
  originalWidth: number;
  originalHeight: number;
};

type MultiSelectStyleType = {
  mainColor: string;
  subColor: string;
};

interface GalleryViewMainProps {
  style?: ViewStyle;
  isMultiSelectEnabled?: boolean;
  multiSelectStyle?: MultiSelectStyleType;
}

export interface NativeViewProps extends GalleryViewMainProps {
  onSelectMedia: (event: NativeSyntheticEvent<MediaData>) => void;
}

export interface GalleryViewProps extends GalleryViewMainProps {
  onSelectMedia?: (event: MediaData) => void;
}

export type GalleryViewHandle = {
  getSelectedMedia: () => Promise<MediaData[]>;
};
