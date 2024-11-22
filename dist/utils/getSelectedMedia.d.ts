import { MediaData } from '../types';
/**
 * Получить выбранные медиафайлы из GalleryView.
 *
 * @param ref - Ссылка на GalleryView (useRef)
 * @returns Promise с массивом медиафайлов
 */
export declare function getSelectedMedia(ref: React.RefObject<any>): Promise<MediaData[]>;
