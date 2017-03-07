import numpy as np
from scipy.spatial.distance import pdist, squareform
from scipy.cluster.hierarchy import dendrogram, linkage
from sklearn.manifold import MDS, TSNE
from matplotlib import pyplot as plt
import scipy.stats

def dissimilarity_matrix(mean_resp, electrodes=None, time=None,
                         dist_type="euclidean", sq_form=True):
    """
    Compute the distance matrix between classes in the neural response.
    Parameters
    ----------
    mean_resp : ndarray
                Three-dimensional input array of neural responses,
                averaged over classes,
                has shape [num_classes x num_electrodes x time].
    electrodes : list or array of ints, optional
                 Indices of electrodes to include in distance measurement.
                 Default is to use all electrodes.
    time : list or array of ints, optional
           Indices of times points to include in distance measurement.
           Default is to use all time points.
    dist_type : string, optional
                String specifying type of distance, valid entries
                are included in scipy.spatial.distance.pdist
                e.g., 'euclidean', 'correlation', 'cosine'
    sq_form : Bool, optional
              If True, use squareform on distance matrix
    Returns
    -------
    D : ndarray
        Distance matrix between all classes,
        has shape [num_classes x num_classes].
    """

    if electrodes is not None:
        if isinstance(electrodes, list):
            electrodes = np.array(electrodes, dtype='int64')
        mean_resp = mean_resp[:,electrodes,:]
    if time is not None:
        if isinstance(time, list):
            time = np.array(time, dtype='int64')
        mean_resp = mean_resp[:,:,time]

    mean_resp = np.reshape(mean_resp, [mean_resp.shape[0],
                                       mean_resp.shape[1]*mean_resp.shape[2]])
    D = pdist(mean_resp, dist_type)
    if sq_form == True:
        D = squareform(D)
    return D

def mds_plot(mean_resp=None, electrodes=None, time=None, plot=True,
             label_map=None, D=None, **kwargs):
    """
    Use multidimensional scaling to visualize neural response
    to different segmental units.
    Parameters
    ----------
    mean_resp : ndarray, optional
                Three-dimensional input array of neural responses,
                averaged over classes,
                has shape [num_classes x num_electrodes x time].
    electrodes : list or array of ints, optional
                 Indices of electrodes to include in distance measurement.
                 Default is to use all electrodes.
    time : list or array of ints, optional
           Indices of times points to include in distance measurement.
           Default is to use all time points.
    plot : Bool
           Boolean indicator of whether to display plot.
           Default is True.
    label_map : dict, optional
                Dictionary with integer keys and string values
                for displaying labels on plot.
    D : ndarray, optional
        Square distance matrix.
        Can be provided instead of `mean_resp`, `electrodes`, `time`.
    kwargs : dict, optional
             Keyword arguments for sklearn.manifold.MDS.
             Default uses sklearn defaults.
    Returns
    -------
    mds_resp : ndarray
               `mean_resp` after dimensionaly reduction with MDS,
               has shape [num_classes x num_dims].
    """

    if D is None:
        if electrodes is not None:
            if isinstance(electrodes, list):
                electrodes = np.array(electrodes, dtype='int64')
            mean_resp = mean_resp[:,electrodes,:]
        if time:
            if isinstance(time, list):
                time = np.array(time, dtype='int64')
            mean_resp = mean_resp[:,:,time]
        mean_resp = np.reshape(mean_resp, [mean_resp.shape[0],
                                           mean_resp.shape[1]*mean_resp.shape[2]])
        mds = MDS(**kwargs)
        mds_resp = mds.fit_transform(mean_resp)
    else:
        kwargs['dissimilarity'] = 'precomputed'
        mds = MDS(**kwargs)
        mds_resp = mds.fit_transform(D)

    if plot == True:
        fig = plt.figure()
        ax = fig.add_subplot(111)
        for k in range(mds_resp.shape[0]):
            if label_map is not None:
                ax.scatter(mds_resp[k,0], mds_resp[k,1],
                           marker='$\mathrm{\mathsf{'+label_map[k]+'}}$',
                           s=100)
            else:
                ax.scatter(mds_resp[k,0], mds_resp[k,1])
        plt.show()

    return mds_resp

def tsne_plot(mean_resp=None, electrodes=None, time=None, plot=True,
              label_map=None, D=None, **kwargs):
    """
    Use t-SNE to visualize neural response
    to different segmental units.
    Parameters
    ----------
    mean_resp : ndarray, optional
                Three-dimensional input array of neural responses,
                averaged over classes,
                has shape [num_classes x num_electrodes x time].
    electrodes : list or array of ints, optional
                 Indices of electrodes to include in distance measurement.
                 Default is to use all electrodes.
    time : list or array of ints, optional
           Indices of times points to include in distance measurement.
           Default is to use all time points.
    plot : Bool
           Boolean indicator of whether to display plot.
           Default is True.
    label_map : dict, optional
                Dictionary with integer keys and string values
                for displaying labels on plot.
    D : ndarray, optional
        Square distance matrix.
        Can be provided instead of `mean_resp`, `electrodes`, `time`.
    kwargs : dict, optional
             Keyword arguments for sklearn.manifold.t_sne.
             Default uses sklearn defaults.
    Returns
    -------
    tsne_resp : ndarray
               `mean_resp` after dimensionaly reduction with MDS,
               has shape [num_classes x num_dims].
    """

    if D is None:
        if electrodes is not None:
            if isinstance(electrodes, list):
                electrodes = np.array(electrodes, dtype='int64')
            mean_resp = mean_resp[:,electrodes,:]
        if time:
            if isinstance(time, list):
                time = np.array(time, dtype='int64')
            mean_resp = mean_resp[:,:,time]
        mean_resp = np.reshape(mean_resp, [mean_resp.shape[0],
                                           mean_resp.shape[1]*mean_resp.shape[2]])
        tsne = TSNE(**kwargs)
        tsne_resp = tsne.fit_transform(mean_resp)
    else:
        kwargs['metric'] = 'precomputed'
        tsne = TSNE(**kwargs)
        tsne_resp = tsne.fit_transform(D)

    if plot == True:
        fig = plt.figure()
        ax = fig.add_subplot(111)
        for k in range(tsne_resp.shape[0]):

            if label_map:
                ax.scatter(tsne_resp[k,0], tsne_resp[k,1],
                           marker='$\mathrm{\mathsf{'+label_map[k]+'}}$',
                           s=100)
            else:
                ax.scatter(tsne_resp[k,0], tsne_resp[k,1])
        plt.show()

    return tsne_resp

def average(resp, labels, exclusion_indices=None):
    """
    Average the neural response according to class of segmental unit.
    Parameters
    ----------
    resp : ndarray
           Three-dimensional input array of neural responses,
           has shape [N_electrodes x time_window x instances].
    labels : list or array of ints
             Class labels for instances.
             len(labels) = resp.shape[2]
    exclusion_indices : list or array of ints, optional
                        Exclude these classes from analysis.
    Returns
    -------
    average : ndarray
              Average of `resp` for each class specified in labels,
              has shape [num_classes x N_electrodes x time].
    """

    classes = list(set(labels))
    average = np.zeros((len(classes), resp.shape[0], resp.shape[1]))

    for k in range(len(classes)):
        class_idx = np.where(labels==classes[k])[0]
        average[k,:,:] = np.mean(resp[:,:,class_idx])

    if exclusion_indices:
        if isinstance(exclusion_indices, list):
            exclusion_indices = np.array(exclusion_indices)
        average = np.delete(average, exclusion_indices, axis=0)

    return average

def dendro(mean_resp, electrodes=None, time=None,
           dist_type="euclidean", link_type="average",
           label_map=None):
    """
    Use multidimensional scaling to visualize neural response
    to different segmental units.
    Parameters
    ----------
    mean_resp : ndarray
                Three-dimensional input array of neural responses,
                averaged over classes,
                has shape [num_classes x num_electrodes x time].
    electrodes : list or array of ints, optional
                 Indices of electrodes to include in distance measurement.
                 Default is to use all electrodes.
    time : list or array of ints, optional
           Indices of times points to include in distance measurement.
           Default is to use all time points.
    dist_type : string, optional
                String specifying type of distance, valid entries
                are included in scipy.spatial.distance.pdist
                e.g., 'euclidean', 'correlation', 'cosine'
    link_type : string, optionalo
                String specifying the linkage type, valid entries
                are included in scipy.cluster.hierarchy.linkage
                e.g., 'average', 'ward'
    label_map : dict, optional
                Dictionary with integer keys and string values
                for displaying labels on plot.
    Returns
    -------
    from docs.scipy.org:
    R : dict
        A dictionary of data structures computed to render the
        dendrogram. Its has the following keys:
        ``'icoords'``
          A list of lists ``[I1, I2, ..., Ip]`` where ``Ik`` is a list of 4
          independent variable coordinates corresponding to the line that
          represents the k'th link painted.
        ``'dcoords'``
          A list of lists ``[I2, I2, ..., Ip]`` where ``Ik`` is a list of 4
          independent variable coordinates corresponding to the line that
          represents the k'th link painted.
        ``'ivl'``
          A list of labels corresponding to the leaf nodes.
        ``'leaves'``
          For each i, ``H[i] == j``, cluster node ``j`` appears in position
          ``i`` in the left-to-right traversal of the leaves, where
          :math:`j < 2n-1` and :math:`i < n`. If ``j`` is less than ``n``, the
          ``i``-th leaf node corresponds to an original observation.
          Otherwise, it corresponds to a non-singleton cluster.

    """
    if electrodes is not None:
        if isinstance(electrodes, list):
            electrodes = np.array(electrodes, dtype='int64')
        mean_resp = mean_resp[:,electrodes,:]
    if time is not None:
        if isinstance(time, list):
            time = np.array(time, dtype='int64')
        mean_resp = mean_resp[:,:,time]

    mean_resp = np.reshape(mean_resp, [mean_resp.shape[0],
                                       mean_resp.shape[1]*mean_resp.shape[2]])
    z = linkage(mean_resp, link_type, metric=dist_type)
    fig = plt.figure()
    ax = fig.add_subplot(111)
    if label_map is not None:
        label_list = list(label_map.values())
        R = dendrogram(z, labels=label_list, orientation='top')
    else:
        R = dendrogram(z, orientation='top')
    plt.show()

    return R

def load_label_strings(label_file):
    """
    Load labels for classes contained in a .txt file.
    Parameters
    ----------
    label_file : string
                 .txt file containing ordered classes (e.g., phonemes),
                 with each string contained in a new line.
    Returns
    -------
    label_strings : list
                    List of newline separated strings in `label_file`
    """

    # phone_file saved as .txt, each line w/ label
    with open(label_file, 'r') as f:
        label_strings = [l.strip('\n') for l in f.readlines()]

    return label_strings

def make_label_map(label_strings, sorted=False):
    """
    Load labels for classes contained in a .txt file.
    Parameters
    ----------
    label_string : list
                   List of newline separated labels for classes.
                   e.g., ['a','b','c','d',...,'z']
    sorted : Bool, optional
             If True, index labels alphabetically
    Returns
    -------
    label_map : dict
                Dictionary with keys denoted by entries in `label_string`,
                values indexed with integers from 1...len(label_string)-1
    """

    # map list of string labels to indices
    if sorted == True:
        label_strings = sorted(label_strings)
    label_map = {k:v for k,v in zip(label_strings, [i for i in range(len(label_strings))])}

    return label_map

def invert_map(label_map):
    # Invert keys/values of a dictionary
    return {v:k for k,v in label_map.items()}

def attribute2phoneme(attribute, mode='arpabet'):
    """
    Return list of phonemes for a given attribute.
    Parameters
    ----------
    attribute : string
                Phonetic feature specifying phoneme attributes.
                Valid strings include any key in `phone_list` (see below).
    mode : string, optional
           String specifying phonetic alphabet.
           Valid options are 'arpabet', 'timit', and 'ipa'
    Returns
    -------
    A list of phonemes with `attribute`.
    """
    phone_list = dict()
    if mode == 'arpabet':
        phone_list['voiced'] = \
            ['AA','AO','OW','AH','UH','UW','IY','IH','EY','EH','AE','AW','AY',
                'OY','W','Y','L','R','M','N','NG','Z','V','DH','B','D','G','CH','JH','ER']
        phone_list['unvoiced'] = ['TH','F','S','SH','P','T','K']
        phone_list['sonorant'] = \
            ['AA','AO','OW','AH','UH','UW','IY','IH','EY','EH','AE','AW','AY',
                'OY','W','Y','L','R','M','N','NG']
        phone_list['syllabic'] = \
            ['AA','AO','OW','AH','UH','UW','IY','IH','EY','EH','AE','AW','AY','OY']
        phone_list['consonantal'] = \
            ['L','R','DH','TH','F','S','SH','Z','V','P','T',
                'K','B','D','G','M','N','NG']
        phone_list['approximant'] = ['W','Y','L','R']
        phone_list['plosive'] = ['P','T','K','B','D','G']
        phone_list['strident'] = ['Z','S','SH']
        phone_list['labial'] = ['P','B','M','F','V']
        phone_list['coronal'] = ['D','T','R','L','N','S','Z','SH']
        phone_list['anterior'] = ['T','D','S','Z','TH','DH','P','B','F','V','M','N','L','R']
        phone_list['dorsal'] = ['K','G','NG']
        phone_list['front'] = ['IY','IH','EH','AE']
        phone_list['back'] = ['UW','UH','AO','AA']
        phone_list['high'] = ['IY','IH','UH','UW']
        phone_list['low'] = ['EH','AE','AA','AO']
        phone_list['nasal'] = ['M','N','NG']
        phone_list['fricative'] = ['F','V','S','Z','SH','TH','DH']
        phone_list['semivowel'] = ['W','L','R','Y']
        phone_list['obstruent'] = ['DH','TH','F','S','SH','Z','V','P','T','K','B','D','G']
    elif mode == 'timit':
        phone_list['voiced'] = \
            ['aa','ao','ow','axh','uxh','uw','iy','ixh','ey','eh','ae','aw','ay',
                'oy','w','y','l','r','m','n','ng','z','v','dh','b','d','g','ch','jh','er']
        phone_list['unvoied'] = ['th','f','s','sh','p','t','k']
        phone_list['sonorant'] = \
            ['aa','ao','ow','axh','uxh','uw','iy','ixh','ey','eh','ae','aw','ay',
                'oy','w','y','l','r','m','n','ng']
        phone_list['syllabic'] = \
            ['aa','ao','ow','axh','uxh','uw','iy','ixh','ey','eh','ae','aw','ay','oy']
        phone_list['consonantal'] = \
            ['l','r','dh','th','f','s','sh','z','v','p','t',
                'k','b','d','g','m','n','ng']
        phone_list['approximant'] = \
            ['aa','ao','ow','axh','uxh','uw','iy','ixh','ey','eh','ae','aw','ay',
                'oy','w','y','l','r']
        phone_list['plosive'] = ['p','t','k','b','d','g']
        phone_list['strident'] = ['z','s','sh']
        phone_list['labial'] = ['p','b','m','f','v']
        phone_list['coronal'] = ['d','t','r','l','n','s','z','sh']
        phone_list['anterior'] = ['t','d','s','z','th','dh','p','b','f','v','m','n','l','r']
        phone_list['dorsal'] = ['k','g','ng']
        phone_list['front'] = ['iy','ixh','eh','ae']
        phone_list['back'] = ['uw','uxh','ao','aa']
        phone_list['high'] = ['iy','ixh','uxh','uw']
        phone_list['low'] = ['eh','ae','aa','ao']
        phone_list['nasal'] = ['m','n','ng']
        phone_list['fricative'] = ['f','v','s','z','sh','th','dh']
        phone_list['semivowel'] = ['w','l','r','y']
        phone_list['obstruent'] = ['dh','th','f','s','sh','z','v','p','t',
                'k','b','d','g']
    elif mode == 'ipa':
        import json
        with open('./arpa2ipa.json', 'r') as f:
            arpa2ipa = json.load(f)
        phone_list['voiced'] = \
            ['AA','AO','OW','AH','UH','UW','IY','IH','EY','EH','AE','AW','AY',
                'OY','W','Y','L','R','M','N','NG','Z','V','DH','B','D','G','CH','JH','ER']
        phone_list['unvoiced'] = ['TH','F','S','SH','P','T','K']
        phone_list['sonorant'] = \
            ['AA','AO','OW','AH','UH','UW','IY','IH','EY','EH','AE','AW','AY',
                'OY','W','Y','L','R','M','N','NG']
        phone_list['syllabic'] = \
            ['AA','AO','OW','AH','UH','UW','IY','IH','EY','EH','AE','AW','AY','OY']
        phone_list['consonantal'] = \
            ['L','R','DH','TH','F','S','SH','Z','V','P','T',
                'K','B','D','G','M','N','NG']
        phone_list['approximant'] = ['W','Y','L','R']
        phone_list['plosive'] = ['P','T','K','B','D','G']
        phone_list['strident'] = ['Z','S','SH']
        phone_list['labial'] = ['P','B','M','F','V']
        phone_list['coronal'] = ['D','T','R','L','N','S','Z','SH']
        phone_list['anterior'] = ['T','D','S','Z','TH','DH','P','B','F','V','M','N','L','R']
        phone_list['dorsal'] = ['K','G','NG']
        phone_list['front'] = ['IY','IH','EH','AE']
        phone_list['back'] = ['UW','UH','AO','AA']
        phone_list['high'] = ['IY','IH','UH','UW']
        phone_list['low'] = ['EH','AE','AA','AO']
        phone_list['nasal'] = ['M','N','NG']
        phone_list['fricative'] = ['F','V','S','Z','SH','TH','DH']
        phone_list['semivowel'] = ['W','L','R','Y']
        phone_list['obstruent'] = ['DH','TH','F','S','SH','Z','V','P','T','K','B','D','G']
        for key, val in phone_list.items():
            phone_list[key] = [arpa2ipa[p.lower()] for p in phone_list[key]]

    if attribute not in phone_list.keys():
        print('Error: input attribute should be included in '+str(phone_list.keys()))

    return phone_list[attribute]

def all_indices(ulist, val):
    indices = []
    idx = -1
    while True:
        try:
            idx = ulist.index(val, idx+1)
            indices.append(idx)
        except ValueError:
            break
    return indices

def f_ratio(dist, labels):

    labels = list(labels)
    if len(dist.shape) == 1:
        dist = np.expand_dims(dist, 0)

    K = len(list(set(labels)))                  # number of groups
    N = dist.shape[-1]                          # number of samples
    global_mean = np.mean(dist, axis=-1)        # global mean

    bgv = np.zeros(K)
    wgv = np.zeros(K)
    n = np.zeros(K)

    for i in range(K):

        # between group variability
        idx = all_indices(labels, i)
        n[i] = float(len(idx))                          # number of observations for group i
        Y_ii = np.mean(dist[:,idx], axis=1)             # sample mean of group_i
        bgv[i] =  np.sum(n[i]*(Y_ii-global_mean)**2)/float(K-1)

        # within group variability
        wgv_j = 0
        for j in range(len(idx)):
            ind_j = idx[j]
            Y_ij = dist[:,ind_j]
            wgv_j += np.sum((Y_ii-Y_ij)**2)/float(N-K)
        wgv[i] = wgv_j

    BGV = sum(bgv)
    WGV = sum(wgv)

    f = BGV/WGV

    return f

def calc_f_ratio(resp, labels, dims='all',
                 electrodes=None, time=None,
                 attribute=None, phn_sub=None):
    """
    Average the neural response according to class of segmental unit.
    Parameters
    ----------
    resp : ndarray
           Three-dimensional input array of neural responses,
           has shape [N_electrodes x time_window x instances].
    labels : list or array of ints
             Class labels for instances.
             len(labels) = resp.shape[2]
    dims : str, optional
           'all' : compute F-ratio for all electrodes together.
           'individual' : compute F-ratio for each electrode separately.
    attribute : str, optional
                String from attribute2phoneme (included in future release).
    phn_sub : list, optional
              Subset of classes (included in future release).
    Returns
    -------
    f : ndarray
        F-ratio for each time point.
        If dims == `all`, has shape (time,)
        If dims == `individual`, has shape (N_electrodes, time)
    """

    if electrodes is not None:
        if isinstance(electrodes, list):
            electrodes = np.array(electrodes, dtype='int64')
        resp = resp[electrodes,:,:]
    if time is not None:
        if isinstance(time, list):
            time = np.array(time, dtype='int64')
        resp = resp[:,time,:]

    #if attribute == 'phonemes' or attribute == None:
    #    num_classes = list(set(labels))
    #else:
    #    phns = attribute2phoneme(attribute)

    if dims == 'all':
        f = np.zeros((resp.shape[1],))
        for t in range(resp.shape[1]):
            f[t] = f_ratio(resp[:,t,:], labels)
    elif dims == 'individual':
        f = np.zeros((resp.shape[0], resp.shape[1]))
        for e in range(resp.shape[0]):
            for t in range(resp.shape[1]):
                f[e,t] = f_ratio(resp[e,t,:], labels)
    return f
