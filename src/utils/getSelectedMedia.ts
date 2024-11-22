import {NativeModules, findNodeHandle} from 'react-native';
import {MediaData} from '../types';

const {GalleryViewManager} = NativeModules;

/**
 * Получить выбранные медиафайлы из GalleryView.
 *
 * @param ref - Ссылка на GalleryView (useRef)
 * @returns Promise с массивом медиафайлов
 */
export async function getSelectedMedia(
  ref: React.RefObject<any>,
): Promise<MediaData[]> {
  try {
    const viewTag = findNodeHandle(ref.current);
    if (!viewTag) {
      throw new Error('GalleryView reference is not attached to a native view');
    }
    const selectedMedia = await GalleryViewManager.getSelectedMedia(viewTag);
    return selectedMedia;
  } catch (error) {
    console.error('Error fetching selected media:', error);
    return [];
  }
}
